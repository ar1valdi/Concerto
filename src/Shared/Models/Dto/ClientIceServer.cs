using System;
using System.Collections.Generic;

namespace Concerto.Shared.Models.Dto;

public class ClientIceServer
{
    public IEnumerable<string> Urls { get; set; } = Array.Empty<string>();
    public string? Username { get; set; }
    public string? Credential { get; set; }
}
