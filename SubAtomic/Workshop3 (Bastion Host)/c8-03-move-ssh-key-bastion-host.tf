# Create NULL Resource and Provisioners
    resource "null_resource" "name" {
    depends_on = [azurerm_linux_virtual_machine.bastionlinuxvm]
}

# Connection Block for Perovisioners to Connect to Azure VM Instance
    Connection {
        type = "ssh"
        host = azurerm_linux_virtual_machine.bastion_host_linuxvm.public_ip_address
        user = azurerm_linux_virtual_machine.bastion_host_linuxvm.admin_username
        private_key = file("${path.module}/ssh-keys/terrform.pem")
}

## File Provisoner: Copies terrform-key.pem to /tmp/terraform-key.pem
    provisioner "file" {
        source = "ssh-keys/terraform-azure.pem"
        destination = "/tmp/terraform-azure.pem"
}

## Remote Exec Provisioner: Using remote-exec provisioner to fix the private key permissions on Bastion Host
    provisioner "remote-exec" {
        inline =[
        "sudo chmod 400 /tmp/terraform-azure.pem"
        ]
}

# Creation-Time Provisioner - by default they are created during resource creation (terraform-apply)
# Destroy-Time Provisioners - Will be execueted during terraform-destroy command