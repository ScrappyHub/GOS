# plugin.json Schema v0.1

## Required Fields
plugin_id (reverse-DNS string)
name
version
type: workload|provider|policy|preos
entrypoints: list
requested_capabilities: list
publisher_key_id: string
required_attestations: object

## Optional Fields
description
homepage
support_contact
lane_recommendation
data_domains (what it touches)
exports (what bundles it can emit)

## Rule
GOS executes only via entrypoints declared here.
No dynamic entrypoints.
No unsigned modules.
