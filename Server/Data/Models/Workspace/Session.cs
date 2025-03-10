using Concerto.Shared.Models.Dto;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;

namespace Concerto.Server.Data.Models;

[Index(nameof(WorkspaceId))]
[Index(nameof(MeetingGuid))]
public class Session : Entity
{
	public string Name { get; set; } = null!;
	public DateTime ScheduledDate { get; set; }
	public long WorkspaceId { get; set; }
	public Workspace Workspace { get; set; } = null!;

	public long FolderId { get; set; }
	public Folder Folder { get; set; } = null!;

	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid MeetingGuid { get; set; }
}

public static partial class ViewModelConversions
{
	public static Dto.Session ToViewModel(this Session session, bool canManage)
	{
		return new Dto.Session(
			session.Id,
			session.Name,
			WorkspaceId: session.WorkspaceId,
			WorkspaceName: session.Workspace.Name,
			ScheduledDateTime: session.ScheduledDate,
			WorkspaceRootFolderId: session.Workspace.RootFolderId!.Value,
			FolderId: session.FolderId,
			MeetingGuid: session.MeetingGuid,
			CanManage: canManage
		);
	}

	public static SessionListItem ToSessionListItem(this Session session)
	{
		return new SessionListItem(session.Id,
			session.Name,
			session.ScheduledDate,
			session.FolderId
		);
	}

	public static SessionSettings ToSettingsViewModel(this Session session)
	{
		return new SessionSettings(session.Id,
			session.Name,
			session.ScheduledDate
		);
	}
}
