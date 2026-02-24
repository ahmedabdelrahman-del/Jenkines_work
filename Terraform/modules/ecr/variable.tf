variable "repository_name" {
  type = string
}

variable "keep_last_images" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "force_delete" {
  type    = bool
  default = false
}