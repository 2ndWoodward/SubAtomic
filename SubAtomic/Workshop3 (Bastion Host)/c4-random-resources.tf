# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = true 
  lower = true
  special = false
  number = true   
}