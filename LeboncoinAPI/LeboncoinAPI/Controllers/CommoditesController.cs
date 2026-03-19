using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class CommoditesController : ControllerBase
{
    private readonly LeboncoinDBContext _context;

    public CommoditesController(LeboncoinDBContext context)
    {
        _context = context;
    }

    // GET: api/Commodites/by-categories
    [HttpGet("by-categories")]
    public async Task<ActionResult<object>> GetCommoditesByCategories()
    {
        var categories = await _context.Categories
            .Where(c => c.Idcategorie >= 1 && c.Idcategorie <= 3)
            .Include(c => c.Commodites)
            .Select(c => new
            {
                Id = c.Idcategorie,
                Nom = c.Nomcategorie,
                Items = c.Commodites.Select(cm => new
                {
                    Id = cm.Idcommodite,
                    Nom = cm.Nomcommodite
                }).ToList()
            })
            .ToListAsync();

        return Ok(categories);
    }
}
