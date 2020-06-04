variable "ami" { 
	default = "ami-0b8d86d4bf91850af"	
}

variable "key_name" { 
	default = "DEVOPS"	
}

variable "cdirs_full_access" {
	type = list
	default = ["xxx.x.xx.xx/32","xx.xxx.x.xx/32"]
}
