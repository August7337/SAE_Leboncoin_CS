using System.Net;
using System.Net.Mail;

namespace LeboncoinAPI.Services;

public class EmailService : IEmailService
{
    private readonly IConfiguration _config;

    public EmailService(IConfiguration config)
    {
        _config = config;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string message)
    {
        // On récupère les infos depuis le .env / appsettings
        var smtpServer = "smtp.gmail.com";
        var smtpPort = 587;
        var senderEmail = _config["EmailSettings:SenderEmail"];
        var appPassword = _config["EmailSettings:AppPassword"]; // Mot de passe d'application

        using var client = new SmtpClient(smtpServer, smtpPort)
        {
            Credentials = new NetworkCredential(senderEmail, appPassword),
            EnableSsl = true
        };

        var mailMessage = new MailMessage
        {
            From = new MailAddress(senderEmail!, "Leboncoin Team"),
            Subject = subject,
            Body = message,
            IsBodyHtml = true
        };

        mailMessage.To.Add(toEmail);

        await client.SendMailAsync(mailMessage);
    }
}