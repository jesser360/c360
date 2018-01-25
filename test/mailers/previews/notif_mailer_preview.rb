# Preview all emails at http://localhost:3000/rails/mailers/notif_mailer
class NotifMailerPreview < ActionMailer::Preview
  def sample_mail_preview
     NotifMailer.sample_email(User.first)
   end
end
