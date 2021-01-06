variable "region" {
  description = "(optional) describe your variable"
  default     = "East US 2"
}
variable "location" {
  default = "eastus2"
}
variable "subnets" {
  type = map(string)
  default = {
    "subnet1" = "10.90.1.0/24"
  }
}
# AKS cluster
variable "aksResourceName" {
  default = "AKS-NGINX-TF-DEMO"
}
variable "aksClusterName" {
  default = "kubernetes-aks1"
}
variable "aksDnsPrefix" {
  default = "kubecluster"
}
variable "aksInstanceSize" {
  default = "Standard_DS3_v2"
}
variable "aksAgentNodeCount" {
  default = "1"
}
variable "podCidr" {
  description = "k8s pod cidr"
  default     = "10.56.0.0/14"
}
variable "kubernetes" {
  default = false
}
