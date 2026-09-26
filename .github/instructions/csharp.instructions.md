---
applyTo: "**/*.cs,**/*.csx,**/*.csproj"
---

# C# guidance

- Follow the root `.editorconfig` for formatting, naming, style, and analyzer
  defaults. ADR 0002 records the rationale and approved settings; do not
  introduce conflicting conventions.
- The API targets .NET 8 and uses ASP.NET Core minimal APIs. Preserve the
  existing target framework, nullable reference type support, and implicit
  usings. Follow the established minimal API structure unless a change warrants
  a broader design.
- Keep nullable annotations meaningful and address nullability warnings rather
  than suppressing them without a clear reason.
- Keep package versions centralized in `Directory.Packages.props`. When changing
  dependencies, update the package version there and refresh the relevant lock
  files with the .NET CLI.
- Before substantial technical changes, review relevant records in `docs/adr/`;
  add an ADR when a meaningful decision is not already documented.
- For C# changes, validate with `dotnet build` and `dotnet test`. The repository
  currently has no test projects.
- When changing application code or configuration, update the relevant
  `docs/wiki/` pages in the same change, as required by
  `.github/copilot-instructions.md`.
