class EmailContactsController < ApplicationController
  def new
    @email_contact = EmailContact.new
  end

  def create
    @email_contact = EmailContact.new(email_contact_params)

    if @email_contact.valid?
      # Logic to send the email (e.g., deliver)
      @email_contact.deliver
      redirect_to success_path # or show a success message
    else
      render :new
    end
  end

  private

  def email_contact_params
    params.require(:email_contact).permit(:name, :email, :message)
  end
end
