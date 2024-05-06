variable "org_external_access_analyzer_name" {
  description = "The name of the organization external access analyzer."
  type        = string
  default     = "OrgExternalAccessAnalyzer"
}

variable "org_unused_access_analyzer_name" {
  description = "The name of the organization unused access analyzer."
  type        = string
  default     = "OrgUnusedAccessAnalyzer"
}

variable "eanble_unused_access" {
  description = "Whether organizational unused access analysis should be enabled."
  type        = bool
  default     = false
}

variable "unused_access_age" {
  description = "The specified access age in days for which to generate findings for unused access."
  type        = number
  default     = 90
}
