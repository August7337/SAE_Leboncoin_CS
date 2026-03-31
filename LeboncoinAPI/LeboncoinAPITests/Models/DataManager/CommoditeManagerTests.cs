using LeboncoinAPI.Models.EntityFramework;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;

[TestClass]
public class CommoditeManagerTests
{
    [TestMethod]
    public async Task GetAllAsync_IncludesCategory()
    {
        // Arrange
        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: "CommoditeTest").ConfigureWarnings(x => x.Ignore(InMemoryEventId.TransactionIgnoredWarning)).Options;
        using var context = new LeboncoinDBContext(options);

        var cat = new Categorie { Idcategorie = 1, Nomcategorie = "Cuisine" };
        context.Commodites.Add(new Commodite
        {
            Idcommodite = 1,
            Nomcommodite = "Four",
            IdcategorieNavigation = cat
        });
        await context.SaveChangesAsync();
        var manager = new CommoditeManager(context);
        // Act
        var results = await manager.GetAllAsync();
        var item = results.First();
        // Assert
        Assert.IsNotNull(item.IdcategorieNavigation);
        Assert.AreEqual("Cuisine", item.IdcategorieNavigation.Nomcategorie);
    }
}