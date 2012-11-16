class UserMailer < ActionMailer::Base
  def log_mail(emails, project)
    @project = project
    mail.attachments['log.zip'] = {:mime_type => 'application/x-gzip',
                                   :content => File.read("#{Rails.root}/public/encrypt/#{project.name}/log.zip")}
    mail(:to => emails, :from => "pansingh@weboniselab.com", :subject => "log file")
  end
end
