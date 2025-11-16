using Concerto.Shared.Models.Dto;

namespace Concerto.Server.Data.Models;

public class Workspace : Entity
{
	public string Name { get; set; } = string.Empty;
	public string Description { get; set; } = string.Empty;

	public DateTime CreatedDate { get; set; }
	public virtual ICollection<WorkspaceUser> WorkspaceUsers { get; set; } = null!;

	public ICollection<Post> Posts { get; set; } = null!;

	public virtual ICollection<Session> Sessions { get; set; } = null!;

	public long? RootFolderId { get; set; }
	public Folder? RootFolder { get; set; } = null!;
}

public static partial class ViewModelConversions
{
	public static Dto.Workspace ToViewModel(this Workspace workspace, bool canManage)
	{
		return new Dto.Workspace(workspace.Id,
			Description: workspace.Description,
			Name: workspace.Name,
			RootFolderId: workspace.RootFolderId!.Value,
			CanManage: canManage
		);
	}

	public static WorkspaceSettings ToSettingsViewModel(this Workspace workspace, Guid userId, WorkspaceUserRole currentUserRole, bool canManage)
	{
		return new WorkspaceSettings(workspace.Id,
			Description: workspace.Description,
			Name: workspace.Name,
			Members: workspace.WorkspaceUsers.Where(cu => cu.UserId != userId).Select(cu => cu.ToViewModel()),
			CurrentUserRole: currentUserRole.ToViewModel(),
			CanManage: canManage
		);
	}

	public static WorkspaceListItem ToWorkspaceListItem(this Workspace workspace)
	{
		return new WorkspaceListItem(workspace.Id, workspace.Name, workspace.Description, workspace.CreatedDate);
	}
}
