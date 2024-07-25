resource "null_resource" "test1" {
  triggers = {
    always_run = timestamp()
  }

  # Define provisioner or other configuration as needed
  provisioner "local-exec" {
    command = "echo woot woot woot woot"
  }
}
