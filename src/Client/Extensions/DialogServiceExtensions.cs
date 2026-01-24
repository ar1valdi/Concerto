using Concerto.Client.UI.Components.Dialogs;
using Concerto.Client.Services;
using Concerto.Shared.Models.Dto;
using MudBlazor;

namespace Concerto.Client.Extensions;

public static class DialogServiceExtensions
{
    public static async Task<bool> ShowConfirmationDialog(
        this IDialogService dialogService,
        ITranslationsService t,
        string title,
        string action,
        string itemType,
        string itemName,
        bool additionalConfirmation = false
    )
    {
        var item = string.IsNullOrEmpty(itemType) ? itemName : t.T("dialogService", "itemWithTypeFormat", itemType, itemName);
        var text = t.T("dialogService", "confirmationDialogText", action, item);
        var parameters = new DialogParameters { ["Text"] = text, ["Confirmation"] = additionalConfirmation };
        var result = await dialogService.Show<ConfirmationDialog>(title, parameters).Result;
        if (result.Canceled) return false;
        return true;
    }

    public static async Task<bool> ShowDeleteManyConfirmationDialog(
        this IDialogService dialogService,
        ITranslationsService t,
        string title,
        string category,
        string items,
        bool additionalConfirmation = false
    )
    {
        var text = t.T("dialogService", "deleteManyConfirmationText", category, items);
        var parameters = new DialogParameters { ["Text"] = text, ["Confirmation"] = additionalConfirmation };
        var result = await dialogService.Show<ConfirmationDialog>(title, parameters).Result;
        if (result.Canceled) return false;
        return true;
    }


    public static async Task ShowInfoDialog(this IDialogService dialogService, string title, string text)
    {
        var parameters = new DialogParameters { ["Text"] = text };
        await dialogService.Show<InfoDialog>(title, parameters).Result;
    }

    public static async Task<FolderItem?> ShowSelectFolderDialog(this IDialogService dialogService, string title, string selectButtonText, long? initialWorkspaceId = null, IEnumerable<long>? excludedIds = null, IEnumerable<long>? excludedWithChildrenIds = null)
    {
		var parameters = new DialogParameters
        {
			["ExcludedIds"] = excludedIds,
			["ExcludedWithChildrenIds"] = excludedWithChildrenIds,
            ["InitialWorkspaceId"] = initialWorkspaceId,
			["SelectButtonText"] = selectButtonText,
		};
		var result = await dialogService.Show<SelectFolderDialog>(title, parameters).Result;
		if (result.Canceled) return null;
		return (FolderItem)result.Data;
    }

    public static async Task<bool> ShowSelectFilesDialog(this IDialogService dialogService, ITranslationsService t, HashSet<FileItem> selectedFiles, long workspaceId)
    {
        var options = new DialogOptions() { FullScreen = true, MaxWidth = MaxWidth.Large };
        var parameters = new DialogParameters
        {
            ["SelectedFiles"] = selectedFiles,
            ["WorkspaceId"] = workspaceId
        };
        var result = await dialogService.Show<SelectFilesDialog>(t.T("dialogService", "selectFilesDialogTitle"), parameters, options).Result;
        if (result.Canceled) return false;
        return true;
    }

    public static async Task<string?> ShowInputStringDialog(this IDialogService dialogService, string title, string placeholder)
    {
        var parameters = new DialogParameters
        {
            ["Placeholder"] = placeholder
        };
        var result = await dialogService.Show<InputStringDialog>(title, parameters).Result;
        if (result.Canceled) return null;
        return (string)result.Data;
    }

    public static async Task<bool> ShowUpdateUserDialog(this IDialogService dialogService, ITranslationsService t, UserIdentity user)
    {
        var parameters = new DialogParameters
        {
            ["User"] = user
        };
        var result = await dialogService.Show<UpdateUserDialog>(t.T("dialogService", "updateUserDialogTitle"), parameters).Result;
        if (result.Canceled) return false;
        return true;
    }


    public static async Task ShowFilePreviewDialog(this IDialogService dialogService, FileItem file)
    {
        var parameters = new DialogParameters
        {
            ["File"] = file
        };
        await dialogService.Show<FilePreviewDialog>(file.FullName, parameters).Result;
    }

}



