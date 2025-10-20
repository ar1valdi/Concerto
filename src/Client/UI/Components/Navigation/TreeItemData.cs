using Concerto.Shared.Models.Dto;

namespace Concerto.Client.UI.Components.Navigation;

public class TreeItemData
{
    public FolderContentItem? Item { get; set; }
    public bool Expanded { get; set; }
    public bool Expandable { get; set; }
    public HashSet<TreeItemData> Children { get; set; } = new();
    public long Id => Item?.Id ?? 0;
    public string Name => Item?.Name ?? "";
    public bool IsFolder => Item is FolderItem;
}