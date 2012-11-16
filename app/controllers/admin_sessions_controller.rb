class AdminSessionsController < ApplicationController
  def new
     @admin_session = AdminSession.new
   end

   #NOTE create admin session
   def create
     @admin_session = AdminSession.new(params[:admin_session])
     if @admin_session.save
       redirect_to admins_path, :notice => "Successfully logged in."
     else
       render :new
     end
   end

   #NOTE Destroy admin session
   def destroy
     @admin_session = AdminSession.find(params[:id])
     @admin_session.destroy
     redirect_to root_url, :notice => "Successfully logged out."
   end
end
