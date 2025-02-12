using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace eCar.Subsrciber
{
    public class EmailService
    {
        public void SendEmail(string message)
        {
            try
            {
                string smtpServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
                int smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
                string fromMail = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? "ecaraplikacija@gmail.com";
                string password = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? "ofai kzfk maog tynq";

                var emailData = JsonConvert.DeserializeObject<EmailModel>(message);
                var senderEmail = emailData.Sender;
                var recipientEmail = emailData.Recipient;
                var subject = emailData.Subject;
                var content = emailData.Content;

                MailMessage MailMessageObj = new MailMessage();

                MailMessageObj.From = new MailAddress(fromMail);
                MailMessageObj.Subject = subject;
                MailMessageObj.To.Add(recipientEmail);
                MailMessageObj.Body = content;

                var smtpClient = new SmtpClient()
                {
                    Host = smtpServer,
                    Port = smtpPort,
                    UseDefaultCredentials=false,
                    EnableSsl = true,
                    Credentials = new NetworkCredential(fromMail, password),
                };
                smtpClient.Send(MailMessageObj);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }

    }
}
