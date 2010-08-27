# TODO: Remove inheritence to Admin::AdminController
#       Move to background task
#       Settings prefrences (ie. mysql and zip commands)
class Admin::BackupsController < Admin::AdminController
  def index
  end
  
  def database    
    connection = YAML.load_file(File.join(RAILS_ROOT, 'config', 'database.yml'))[params[:env] || RAILS_ENV]    
    render :text => 'Database must be MySQL' and return unless connection['adapter'] == 'mysql'
    
    target_file = RAILS_ROOT + '/tmp/backup.sql'
    File.delete(target_file) if File.exists? target_file

    cmd = build_command(connection, target_file)

    if system("#{cmd}")
      send_file target_file, :filename => "#{connection['database']}_#{Time.now.strftime('%d-%m-%y')}.sql"
    else
      render :text => "#{cmd} <br>Backup failed!" and return
    end
  end
  
  def files    
    if request.post?     
      paths = []
      errors = []
      
      params[:paths].each do |path|
        next if path.blank?
        path = File.join(RAILS_ROOT, 'public', path)
        if File.exists? path
          paths << path
        else
          errors << "Path does not exist: #{path}"
        end
    
        errors << 'No paths given' if paths.empty?
    
        unless errors.empty?
          render :text => errors.inspect and return
        end    
      end
    
      # archive
      target_file = RAILS_ROOT + '/tmp/backup.zip'
      File.delete(target_file) if File.exists? target_file
      
      paths.each do |p|

        cmd = "zip -r9 #{target_file} #{p}"
        unless system("#{cmd}")
          errors << "Failed to add: #{p}"
        end
      end

      filename = params[:filename] || 'files'

      if errors.empty?
        send_file target_file, :filename => "#{filename}_#{Time.now.strftime('%d-%m-%y')}.zip"
      else
        render :text => "#{errors.inspect} <br>Backup failed!" and return
      end
    end
  end
  
  private 
  
  def build_command(connection, filename)
    pswd = "-p" + connection['password'] unless connection['password'].blank?
    user = "-u" + connection['username'] unless connection['username'].blank?
    options = "#{pswd} #{user}"
    "mysqldump #{options} #{connection['database']} > #{filename}"    
  end
end