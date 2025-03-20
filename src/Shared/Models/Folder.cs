﻿using Newtonsoft.Json;
using System.Diagnostics.CodeAnalysis;

namespace Concerto.Shared.Models.Dto;

public record FolderContent
{
	public FolderPermission WorkspacePermission { get; init; } = null!;
	public FolderItem Self { get; init; } = null!;
	public long WorkspaceId { get; init; }
	public virtual IEnumerable<FolderItem> SubFolders { get; init; } = Enumerable.Empty<FolderItem>();
	public virtual IEnumerable<FileItem> Files { get; init; } = Enumerable.Empty<FileItem>();
}

public record FolderContentItem(
	long Id,
	string Name,
	bool CanEdit,
	bool CanDelete
) : EntityModel(Id);

public class FolderContentItemIdEqualityComparer : IEqualityComparer<FolderContentItem>
{
	public bool Equals(FolderContentItem? x, FolderContentItem? y)
	{
		return x?.GetType() == y?.GetType() && x?.Id == y?.Id;
	}

	public int GetHashCode([DisallowNull] FolderContentItem obj)
	{
		return obj.Id.GetHashCode() + (obj.GetType()).GetHashCode();
	}
}

public record FolderItem(
	long Id,
	string Name,
	string OwnerFullName,
	bool CanWrite,
	bool CanEdit,
	bool CanDelete,
	FolderType Type
) : FolderContentItem(Id, Name, CanEdit, CanDelete)
{
	public bool IsPermanent => Type is FolderType.WorkspaceRoot or FolderType.Sessions;
}

public record FileItem(
	long Id,
	string Name,
	string Extension,
	string MimeType,
	long Size,
	string OwnerFullName,
	bool CanEdit,
	bool CanDelete
) : FolderContentItem(Id, Name, CanEdit, CanDelete)
{
	public string FullName => $"{Name}{Extension}";
}

public record FolderSettings(
	long Id,
	string Name,
	Guid? OwnerId,
	long WorkspaceId,
	FolderType Type,
	FolderPermission WorkspacePermission,
	FolderPermission? ParentWorkspacePermission,
	IEnumerable<UserFolderPermission> UserPermissions,
	IEnumerable<UserFolderPermission> ParentUserPermissions
) : EntityModel(Id)
{
	public bool IsPermanent => Type is FolderType.WorkspaceRoot or FolderType.Sessions;
}
public record UserFolderPermission(User User, FolderPermission Permission)
{
	public User User { get; set; } = User;
	public FolderPermission Permission { get; set; } = Permission;
}

public class UserFolderPermissionIdEqualityComparer : IEqualityComparer<UserFolderPermission>
{
	public bool Equals(UserFolderPermission? x, UserFolderPermission? y)
	{
		return x?.User.Id == y?.User.Id;
	}

	public int GetHashCode([DisallowNull] UserFolderPermission obj)
	{
		return obj.User.Id.GetHashCode();
	}
}

public record FolderPermission(FolderPermissionType Type, bool Inherited);

public enum FolderPermissionType
{
	Read = 0,
	ReadWriteOwned = 1,
	ReadWrite = 2
}

public enum FolderType
{
	WorkspaceRoot,
	Sessions,
	Sheets,
	Recordings,
	Video,
	Audio,
	Documents,
	Other
}

public static class FolderTypeExtensions
{
	public static string ToDisplayString(this FolderType type)
	{
		return type switch
		{
			FolderType.WorkspaceRoot => "Workspace Root",
			FolderType.Sessions => "Session recordings",
			FolderType.Sheets => "Music scores",
			FolderType.Recordings => "Recordings",
			FolderType.Video => "Video",
			FolderType.Audio => "Audio",
			FolderType.Documents => "Documents",
			FolderType.Other => "Other",
			_ => throw new ArgumentOutOfRangeException(nameof(type), type, null)
		};
	}
}

public record CreateFolderRequest
{
	public long ParentId { get; set; }
	public string Name { get; set; } = string.Empty;
	public FolderType Type { get; set; } = FolderType.Other;
	public FolderPermission WorkspacePermission { get; set; } = null!;
}

public record UpdateFolderRequest : EntityModel
{
	public UpdateFolderRequest(long Id) : base(Id) { }

	public string Name { get; set; } = null!;
	public FolderType Type { get; set; }
	public FolderPermission WorkspacePermission { get; set; } = null!;
	public virtual HashSet<UserFolderPermission> UserPermissions { get; set; } = null!;
	public bool forceInherit { get; set; }
}

public record MoveFolderItemsRequest
{
	public IEnumerable<long> FolderIds { get; set; } = null!;
	public IEnumerable<long> FileIds { get; set; } = null!;
	public long DestinationFolderId { get; set; }
}

public record CopyFolderItemsRequest
{
	public IEnumerable<long> FolderIds { get; set; } = null!;
	public IEnumerable<long> FileIds { get; set; } = null!;
	public long DestinationFolderId { get; set; }
}

public record DeleteFolderItemsRequest
{
	public IEnumerable<long> FolderIds { get; set; } = null!;
	public IEnumerable<long> FileIds { get; set; } = null!;
}

public class FileChunkMetadata
{
	[JsonProperty("Offset")]
	public long Offset { get; set; }
	[JsonProperty("FileSize")]
	public long FileSize { get; set; }
	[JsonProperty("FolderId")]
	public long FolderId { get; set; }
	[JsonProperty("Guid")]
	public Guid Guid { get; set; }
}


