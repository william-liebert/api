# ADR 0002: Adopt a repository-wide C# .editorconfig

- Status: Accepted
- Date: 2026-09-26

## Context

The repository currently has no `.editorconfig`, so formatting, style, naming, and analyzer behavior can vary by IDE and local defaults. This creates inconsistent code reviews and avoidable churn.

## Decision

Adopt a root-level `.editorconfig` for the entire repository, with explicit C# and .NET defaults for formatting, style, naming, and analyzer severities.

The configured options and approved values are:

| Section | Option | Value |
| --- | --- | --- |
| `(global)` | `root` | `true` |
| `[*]` | `charset` | `utf-8` |
| `[*]` | `end_of_line` | `lf` |
| `[*]` | `insert_final_newline` | `true` |
| `[*]` | `indent_style` | `space` |
| `[*]` | `indent_size` | `4` |
| `[*]` | `trim_trailing_whitespace` | `true` |
| `[*.md]` | `trim_trailing_whitespace` | `false` |
| `[*.{cs,csx}]` | `indent_size` | `4` |
| `[*.{cs,csx}]` | `tab_width` | `4` |
| `[*.{cs,csx}]` | `csharp_new_line_before_open_brace` | `all` |
| `[*.{cs,csx}]` | `csharp_new_line_before_else` | `true` |
| `[*.{cs,csx}]` | `csharp_new_line_before_catch` | `true` |
| `[*.{cs,csx}]` | `csharp_new_line_before_finally` | `true` |
| `[*.{cs,csx}]` | `csharp_new_line_between_query_expression_clauses` | `true` |
| `[*.{cs,csx}]` | `csharp_indent_case_contents` | `true` |
| `[*.{cs,csx}]` | `csharp_indent_switch_labels` | `true` |
| `[*.{cs,csx}]` | `csharp_indent_labels` | `one_less_than_current` |
| `[*.{cs,csx}]` | `csharp_space_after_cast` | `false` |
| `[*.{cs,csx}]` | `csharp_space_after_keywords_in_control_flow_statements` | `true` |
| `[*.{cs,csx}]` | `csharp_space_between_method_call_parameter_list_parentheses` | `false` |
| `[*.{cs,csx}]` | `csharp_space_between_method_declaration_parameter_list_parentheses` | `false` |
| `[*.{cs,csx}]` | `csharp_space_between_parentheses` | `false` |
| `[*.{cs,csx}]` | `csharp_space_before_colon_in_inheritance_clause` | `true` |
| `[*.{cs,csx}]` | `csharp_space_after_colon_in_inheritance_clause` | `true` |
| `[*.{cs,csx}]` | `csharp_space_around_binary_operators` | `before_and_after` |
| `[*.{cs,csx}]` | `csharp_space_between_method_declaration_empty_parameter_list_parentheses` | `false` |
| `[*.{cs,csx}]` | `csharp_space_between_method_call_empty_parameter_list_parentheses` | `false` |
| `[*.{cs,csx}]` | `csharp_space_before_open_square_brackets` | `false` |
| `[*.{cs,csx}]` | `csharp_space_between_empty_square_brackets` | `false` |
| `[*.{cs,csx}]` | `csharp_space_between_square_brackets` | `false` |
| `[*.{cs,csx}]` | `csharp_preserve_single_line_blocks` | `true` |
| `[*.{cs,csx}]` | `csharp_preserve_single_line_statements` | `false` |
| `[*.{cs,csx}]` | `csharp_preferred_modifier_order` | `public,protected,internal,private,protected_internal,private_protected,file,static,extern,new,virtual,abstract,sealed,override,readonly,unsafe,required,volatile,async:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_var_for_built_in_types` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_var_when_type_is_apparent` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_var_elsewhere` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_methods` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_constructors` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_operators` | `when_on_single_line:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_properties` | `when_on_single_line:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_indexers` | `when_on_single_line:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_expression_bodied_accessors` | `when_on_single_line:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_pattern_matching_over_is_with_cast_check` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_pattern_matching_over_as_with_null_check` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_inlined_variable_declaration` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_throw_expression` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_conditional_delegate_call` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_switch_expression_over_statement` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_primary_constructors` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_namespace_declarations` | `file_scoped:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_utf8_string_literals` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_prefer_braces` | `true:warning` |
| `[*.{cs,csx}]` | `csharp_style_prefer_simple_using_statement` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_simple_default_expression` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_local_over_anonymous_function` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_null_check_over_type_check` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_method_group_conversion` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_prefer_top_level_statements` | `false:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_deconstructed_variable_declaration` | `true:suggestion` |
| `[*.{cs,csx}]` | `csharp_style_implicit_object_creation_when_type_is_apparent` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_qualification_for_field` | `false:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_qualification_for_property` | `false:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_qualification_for_method` | `false:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_qualification_for_event` | `false:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_predefined_type_for_locals_parameters_members` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_predefined_type_for_member_access` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_parentheses_in_arithmetic_binary_operators` | `always_for_clarity:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_parentheses_in_relational_binary_operators` | `always_for_clarity:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_parentheses_in_other_binary_operators` | `always_for_clarity:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_parentheses_in_other_operators` | `never_if_unnecessary:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_require_accessibility_modifiers` | `for_non_interface_members:warning` |
| `[*.{cs,csx}]` | `dotnet_style_object_initializer` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_collection_initializer` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_collection_expression` | `when_types_loosely_match:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_explicit_tuple_names` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_coalesce_expression` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_null_propagation` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_is_null_check_over_reference_equality_method` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_auto_properties` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_conditional_expression_over_assignment` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_conditional_expression_over_return` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_compound_assignment` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_simplified_boolean_expressions` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_prefer_simplified_interpolation` | `true:suggestion` |
| `[*.{cs,csx}]` | `dotnet_style_readonly_field` | `true:warning` |
| `[*.{cs,csx}]` | `dotnet_code_quality_unused_parameters` | `non_public:suggestion` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_prefixed_with_i.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_prefixed_with_i.symbols` | `interface_symbols` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_prefixed_with_i.style` | `interface_style` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.interface_symbols.applicable_kinds` | `interface` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.interface_symbols.applicable_accessibilities` | `*` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.interface_symbols.required_modifiers` | `` |
| `[*.{cs,csx}]` | `dotnet_naming_style.interface_style.required_prefix` | `I` |
| `[*.{cs,csx}]` | `dotnet_naming_style.interface_style.capitalization` | `pascal_case` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_pascal_case.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_pascal_case.symbols` | `interface_symbols` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.interfaces_should_be_pascal_case.style` | `pascal_case_style` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.types_should_be_pascal_case.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.types_should_be_pascal_case.symbols` | `type_symbols` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.types_should_be_pascal_case.style` | `pascal_case_style` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.type_symbols.applicable_kinds` | `class,struct,record,enum,delegate` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.type_symbols.applicable_accessibilities` | `*` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.type_symbols.required_modifiers` | `` |
| `[*.{cs,csx}]` | `dotnet_naming_style.pascal_case_style.capitalization` | `pascal_case` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.private_fields_should_be_underscore_camel_case.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.private_fields_should_be_underscore_camel_case.symbols` | `private_fields` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.private_fields_should_be_underscore_camel_case.style` | `private_field_underscore_style` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.private_fields.applicable_kinds` | `field` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.private_fields.applicable_accessibilities` | `private` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.private_fields.required_modifiers` | `` |
| `[*.{cs,csx}]` | `dotnet_naming_style.private_field_underscore_style.capitalization` | `camel_case` |
| `[*.{cs,csx}]` | `dotnet_naming_style.private_field_underscore_style.required_prefix` | `_` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.constants_should_be_pascal_case.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.constants_should_be_pascal_case.symbols` | `constants` |
| `[*.{cs,csx}]` | `dotnet_naming_rule.constants_should_be_pascal_case.style` | `pascal_case_style` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.constants.applicable_kinds` | `field` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.constants.applicable_accessibilities` | `public,internal,protected,protected_internal,private_protected` |
| `[*.{cs,csx}]` | `dotnet_naming_symbols.constants.required_modifiers` | `const` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.CA2000.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.CA2012.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.CA2201.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.CA2254.severity` | `warning` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.IDE0005.severity` | `suggestion` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.IDE0051.severity` | `suggestion` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.IDE0060.severity` | `suggestion` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.IDE0160.severity` | `suggestion` |
| `[*.{cs,csx}]` | `dotnet_diagnostic.IDE0161.severity` | `suggestion` |

## Consequences

- Contributors and automation use the same formatting and style baseline.
- C# language usage and naming are standardized across current and future projects.
- Analyzer severity defaults are explicit, reducing environment-specific differences.
- Future style changes should be made by updating this ADR and the `.editorconfig` together.
