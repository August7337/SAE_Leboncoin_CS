using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[TestClass]
public class ProfessionnelsControllerTests
{
    private ProfessionnelsController _controller;
    private LeboncoinDBContext _context;

    [TestInitialize]
    public void TestSetup()
    {
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new LeboncoinDBContext(options);
        _controller = new ProfessionnelsController(_context);
    }
    [TestMethod]
    public async Task GetProfessionnel_ExistingId_ReturnsProfessionnel()
    {
        var pro = new Professionnel
        {
            Idutilisateur = 1,
           
            Secteuractivite = "Immobilier", 
            Nomsociete = "Ma Boite"     
        };
        _context.Professionnels.Add(pro);
        await _context.SaveChangesAsync();
        var result = await _controller.GetProfessionnel(1);
        Assert.IsNotNull(result.Value);
        Assert.AreEqual("Ma Boite", result.Value.Nomsociete);
    }

    [TestMethod]
    public async Task GetProfessionnel_UnknownId_ReturnsNotFound()
    {
        var result = await _controller.GetProfessionnel(999);
        Assert.IsInstanceOfType(result.Result, typeof(NotFoundResult));
    }
    [TestMethod]
    public async Task PutProfessionnel_ValidUpdate_ReturnsNoContent()
    {
        var proId = 10;
        var proInitial = new Professionnel
        {
            Idutilisateur = proId,
          
            Secteuractivite = "Informatique",
            Nomsociete = "Ma Boite SAS"       
        };

        _context.Professionnels.Add(proInitial);
        await _context.SaveChangesAsync();
        _context.Entry(proInitial).State = EntityState.Detached;
        var proUpdated = new Professionnel
        {
            Idutilisateur = proId,
            Secteuractivite = "Informatique", 
            Nomsociete = "Nouveau Nom"       
        };
        var result = await _controller.PutProfessionnel(proId, proUpdated);
        Assert.IsInstanceOfType(result, typeof(NoContentResult));

        var proInDb = await _context.Professionnels.AsNoTracking()
                                    .FirstOrDefaultAsync(p => p.Idutilisateur == proId);
        Assert.AreEqual("Nouveau Nom", proInDb.Nomsociete);
    }

    [TestMethod]
    public async Task PutProfessionnel_MismatchedId_ReturnsBadRequest()
    {
        var pro = new Professionnel
        {
            Idutilisateur = 1,
           
            Secteuractivite = "Immobilier", 
            Nomsociete = "Ma Boite SAS"     
        };
        var result = await _controller.PutProfessionnel(2, pro); // ID 2 vs ID 1
        Assert.IsInstanceOfType(result, typeof(BadRequestResult));
    }
    [TestMethod]
    public async Task PostProfessionnel_ValidData_ReturnsCreated()
    {
        var pro = new Professionnel
        {
            Idutilisateur = 1,
            Secteuractivite = "Immobilier", 
            Nomsociete = "Ma Boite SAS"     
        };
        var result = await _controller.PostProfessionnel(pro);
        Assert.IsInstanceOfType(result.Result, typeof(CreatedAtActionResult));
    }
    [TestMethod]
    public async Task DeleteProfessionnel_ExistingId_ReturnsNoContent()
    {
        var pro = new Professionnel
        {
            Idutilisateur = 1,
            
            Secteuractivite = "Immobilier", 
            Nomsociete = "Ma Boite SAS"    
        };
        _context.Professionnels.Add(pro);
        await _context.SaveChangesAsync();
        var result = await _controller.DeleteProfessionnel(1);
        Assert.IsInstanceOfType(result, typeof(NoContentResult));
        Assert.IsNull(await _context.Professionnels.FindAsync(1));
    }

    [TestMethod]
    public async Task DeleteProfessionnel_UnknownId_ReturnsNotFound()
    {
        var result = await _controller.DeleteProfessionnel(999);
        Assert.IsInstanceOfType(result, typeof(NotFoundResult));
    }
}