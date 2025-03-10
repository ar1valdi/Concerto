using Microsoft.EntityFrameworkCore;

namespace Concerto.Server.Data.Models;

[Index(nameof(WorkspaceId))]
[Index(nameof(UserId))]
public class WorkspaceUser
{
	public long WorkspaceId { get; set; }
	public Workspace Workspace { get; set; } = null!;
	public Guid UserId { get; set; }
	public User User { get; set; } = null!;
	public WorkspaceUserRole Role { get; set; }

	public WorkspaceUser() { }


	public WorkspaceUser(Guid userId, WorkspaceUserRole role)
	{
		WorkspaceId = Entity.NoId;
		UserId = userId;
		Role = role;
	}
	public WorkspaceUser(long workspaceId, Guid userId, WorkspaceUserRole role)
	{
		WorkspaceId = workspaceId;
		UserId = userId;
		Role = role;
	}


}

public enum WorkspaceUserRole
{
	Admin = 0,
	Supervisor = 1,
	Member = 2
}

public static partial class ViewModelConversions
{
	public static Dto.WorkspaceUser ToViewModel(this WorkspaceUser workspaceUser)
	{
		return new Dto.WorkspaceUser(workspaceUser.UserId, workspaceUser.Role.ToViewModel());
	}

	public static WorkspaceUser ToEntity(this Dto.WorkspaceUser workspaceUser, long workspaceId = 0)
	{
		return new WorkspaceUser
		{
			WorkspaceId = workspaceId,
			UserId = workspaceUser.UserId,
			Role = workspaceUser.Role.ToEntity()
		};
	}

	public static WorkspaceUserRole ToEntity(this Dto.WorkspaceUserRole role)
	{
		switch (role)
		{
			case Dto.WorkspaceUserRole.Admin:
				return WorkspaceUserRole.Admin;
			case Dto.WorkspaceUserRole.Supervisor:
				return WorkspaceUserRole.Supervisor;
			case Dto.WorkspaceUserRole.Member:
				return WorkspaceUserRole.Member;
			default:
				throw new ArgumentOutOfRangeException(nameof(role), role, null);
		}
	}

	public static Dto.WorkspaceUserRole ToViewModel(this WorkspaceUserRole role)
	{
		switch (role)
		{
			case WorkspaceUserRole.Admin:
				return Dto.WorkspaceUserRole.Admin;
			case WorkspaceUserRole.Supervisor:
				return Dto.WorkspaceUserRole.Supervisor;
			case WorkspaceUserRole.Member:
				return Dto.WorkspaceUserRole.Member;
			default:
				throw new ArgumentOutOfRangeException(nameof(role), role, null);
		}
	}
}
