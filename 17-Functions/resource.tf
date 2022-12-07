locals { 
  default = timestamp()
}

output "time" { 
  value = local.default
}

locals { 
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp()) 
}


output "time2" { 
  value = local.time
}


locals { 
  file-1 = fileexists("${path.module}/hello.txt") 
}


output "time-f" { 
  value = local.file-1
}


/*
locals { 
  file-2 = file("${path.module}/hello.txt") 
}


output "time-2" { 
  value = local.file-2
}
*/

locals { 
  filecondition = fileexists("${path.module}/hello.txt") ? file("${path.module}/hello.txt") : local.default_content
}

locals { 
  default_content = "No file found, please make sure file exists.!!"
}

output "testcondition" { 
  value = local.filecondition
}



