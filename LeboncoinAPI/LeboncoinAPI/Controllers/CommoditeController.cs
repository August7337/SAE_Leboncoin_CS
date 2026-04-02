using LeboncoinAPI.Models.EntityFramework;
using Microsoft.AspNetCore.Mvc;

[Route("api/[controller]")]
[ApiController]
public class CommoditesController : ControllerBase
{
    private readonly ICommoditeRepository _repository;

    public CommoditesController(ICommoditeRepository repository)
    {
        _repository = repository;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Commodite>>> Get()
    {
        var result = await _repository.GetAllAsync();
        return Ok(result);
    }
}