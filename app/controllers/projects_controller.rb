require 'crypt/blowfish'
require 'getoptlong'
class ProjectsController < ApplicationController
  before_filter :should_be_login
  before_filter :create_file, :only => [:create_encrypt_file]
  after_filter :zip_file, :only => [:create_encrypt_file]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  #def edit
  #  @project = Project.find(params[:id])
  #end

  def create_encrypt_file
    filepath = "#{Rails.root}/public/encrypt/#{@project.name}/rubynetco"
    log_filepath = "#{Rails.root}/public/encrypt/#{@project.name}/decrunlog.rb"
    begin
      enc_filename = "#{filepath}.enc"
      log_enc_filename = "#{log_filepath}.enc"
      blowfish = Crypt::Blowfish.new(@key)
      blowfish.encrypt_file(filepath, enc_filename)
      blowfish = Crypt::Blowfish.new(@password)
      blowfish.encrypt_file(log_filepath, log_enc_filename)
    rescue Exception
    end
    redirect_to projects_path, :notice => "Project created successfully!"
  end

  def send_mail
    @project = Project.find(params[:id])
  end

  def deliver_mail
    @project = Project.find(params[:id])
    emails = params[:email].gsub(/\r/,"").gsub(/\n/,"").gsub(" ","")
    emails.split(",").each do |email|
      #if (email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i).nil?
      if (email =~ /\A[\w+\-.]+@weboniselab.com+\z/i).nil?
        @project.errors.messages[:email] = ["is invalid(#{email})"]
        break;
      end
    end
    if @project.errors.messages.empty?
      UserMailer.log_mail(emails, @project).deliver
      redirect_to projects_path, :notice => "mail delivered successfully!"
    else
      render "send_mail"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    system "rm -rf #{Rails.root}/public/encrypt/#{@project.name}"
    @project.delete
    redirect_to projects_path

  end

  protected

  def create_file
    if (params[:user_name].empty? || params[:password].empty? || params[:host].empty? || params[:log_path].empty?)
      redirect_to new_project_path, :alert => "All field mandatory."
    else
      @project = Project.new(:name => params[:project_name])
      if @project.save
        system "mkdir #{Rails.root}/public/encrypt/#{@project.name}"
        @key = SecureRandom.base64(15).tr('+/=', '').strip.delete("\n")
        @password = SecureRandom.base64(15).tr('+/=', '').strip.delete("\n")
        @project.create_file(params[:host], params[:user_name],params[:password], params[:log_path], @key, @password)
      else
        render "new"
      end
    end
  end

  def zip_file
    folder = "#{Rails.root}/public/encrypt/#{@project.name}"
    input_filenames = ["decrunlog.rb.enc", "rubynetco.enc", "log.rb"]
    zipfile_name = "#{Rails.root}/public/encrypt/#{@project.name}/log.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, folder + '/' + filename)
      end
    end
    #UserMailer.log_mail("simanchala@weboniselab.com").deliver
  end
end
