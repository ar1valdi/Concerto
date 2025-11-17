using Concerto.Server.Middlewares;
using Concerto.Server.Services;
using Concerto.Shared.Extensions;
using Concerto.Shared.Models.Dto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Concerto.Server.Controllers;

[Route("[controller]/[action]")]
[ApiController]
[Authorize]
public class WorkspaceController : ControllerBase
{
	private readonly WorkspaceService _workspaceService;
	private readonly ILogger<WorkspaceController> _logger;


	public WorkspaceController(ILogger<WorkspaceController> logger, WorkspaceService workspaceService)
	{
		_logger = logger;
		_workspaceService = workspaceService;
	}

	private Guid UserId => HttpContext.UserId();

	[HttpGet]
	public async Task<ActionResult<IEnumerable<WorkspaceListItem>>> GetCurrentUserWorkspaces()
	{
		var test = this.HttpContext;
		if (User.IsAdmin()) return Ok(await _workspaceService.GetAllWorkspaces());
		return Ok(await _workspaceService.GetUserWorkspacesList(UserId));
	}

	[HttpGet]
	public async Task<ActionResult<Workspace>> GetWorkspace(long workspaceId)
	{
		var isAdmin = User.IsAdmin();
		if (isAdmin || await _workspaceService.IsUserWorkspaceMember(UserId, workspaceId))
		{
			var workspace = await _workspaceService.GetWorkspace(workspaceId, UserId, isAdmin);
			if (workspace == null) return NotFound();
			return Ok(workspace);
		}

		return Forbid();
	}

	[HttpGet]
	public async Task<ActionResult<WorkspaceSettings>> GetWorkspaceSettings(long workspaceId)
	{
		var isAdmin = User.IsAdmin();
		if (isAdmin || await _workspaceService.CanManageWorkspace(workspaceId, UserId))
		{
			var workspaceSettings = await _workspaceService.GetWorkspaceSettings(workspaceId, UserId, isAdmin);
			if (workspaceSettings == null) return NotFound();
			return Ok(workspaceSettings);
		}

		return Forbid();
	}

	[HttpGet]
	public async Task<ActionResult<IEnumerable<User>>> GetWorkspaceUsers(long workspaceId)
	{
		if (User.IsAdmin() || await _workspaceService.IsUserWorkspaceMember(UserId, workspaceId))
		{
			var workspaceUsers = await _workspaceService.GetWorkspaceUsers(workspaceId);
			return Ok(workspaceUsers);
		}

		return Forbid();
	}
}
