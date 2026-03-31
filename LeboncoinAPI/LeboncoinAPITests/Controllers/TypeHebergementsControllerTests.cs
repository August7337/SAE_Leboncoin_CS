using LeboncoinAPI.Controllers;
using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeboncoinAPI.Tests;

[TestClass]
public class TypeHebergementsControllerTests
{
    private LeboncoinDBContext _context;
    private TypeHebergementsController _controller;

    [TestInitialize]
    public void TestSetup()
    {        var options = new DbContextOptionsBuilder<LeboncoinDBContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new LeboncoinDBContext(options);
        _controller = new TypeHebergementsController(_context);
    }

    [TestMethod]
    public async Task GetTypeHebergements_ReturnsAllItems()
    {
        // Arrange
        var typesTestData = new List<Typehebergement>
    {
        new Typehebergement { Idtypehebergement = 1, Nomtypehebergement = "Appartement" },
        new Typehebergement { Idtypehebergement = 2, Nomtypehebergement = "Maison" }
    };
        _context.Typehebergements.AddRange(typesTestData);
        await _context.SaveChangesAsync();
        // Act
        var actionResult = await _controller.GetTypeHebergements();
        IEnumerable<Typehebergement> model;
        if (actionResult.Value != null)
        {
            model = actionResult.Value;
        }
        else
        {
            var okResult = actionResult.Result as OkObjectResult;
            model = okResult.Value as IEnumerable<Typehebergement>;
        }

        var list = model.ToList();

        // Assert
        Assert.IsNotNull(list, "La liste ne doit pas être nulle");
        Assert.AreEqual(2, list.Count);
        Assert.AreEqual("Appartement", list[0].Nomtypehebergement);
        Assert.AreEqual("Maison", list[1].Nomtypehebergement);
    }

    [TestMethod]
    public async Task GetTypeHebergements_ReturnsEmpty_WhenNoData()
    {
        // Act
        var result = await _controller.GetTypeHebergements();

        // Assert
        Assert.IsNotNull(result.Value);
        Assert.AreEqual(0, result.Value.Count());
    }
}