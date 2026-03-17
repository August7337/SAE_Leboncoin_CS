using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LeboncoinAPI.Controllers;

[Route("api/[controller]")]
[ApiController]
public class TypeHebergementsController : ControllerBase
{
    private readonly LeboncoinDBContext _context;

    public TypeHebergementsController(LeboncoinDBContext context)
    {
        _context = context;
    }

    // GET: api/TypeHebergements
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Typehebergement>>> GetTypeHebergements()
    {
        return await _context.Typehebergements.ToListAsync();
    }
}
