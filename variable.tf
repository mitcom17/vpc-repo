# VPC Variables
variable "seunvpccidr" {
  default       = "172.16.0.0/16"
  description   = "seun aws vpc cidr"
  type          = string

}

variable "seun-public-subnet1-cidr" {
  default       = "172.16.1.0/24"
  description   = "seun first public subnet cidr"
  type          = string

}

variable "seun-public-subnet2-cidr" {
  default       = "172.16.2.0/24"
  description   = "seun second public subnet cidr"
  type          = string

}

variable "seun-app-subnet1-cidr" {
  default       = "172.16.3.0/24"
  description   = "seun first app subnet cidr"
  type          = string

}

variable "seun-app-subnet2-cidr" {
  default       = "172.16.4.0/24"
  description   = "seun second app subnet cidr"
  type          = string

}

variable "seun-database-subnet1-cidr" {
  default       = "172.16.5.0/24"
  description   = "seun first database subnet cidr"
  type          = string

}

variable "seun-database-subnet2-cidr" {
  default       = "172.16.6.0/24"
  description   = "seun second database subnet cidr"
  type          = string

}