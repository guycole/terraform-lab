#
# Title:fastly1.tf
# Description:
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
#locals {
#  conditions = {
#    ssl = "Request using SSL last priority"
#    error = "Fastly Error"
#    block = "Blocked IPs"
#  }
#
#  snippets = [
#    {
#      name = "API error envelope"
#      type = "error"
#      content = file(""),
#      enabled = "true"
#    }
#  ]
#
#  acls = [
#    name = local.conditions.block,
#    entries = var.blocked_ips
#  ]
#}

curl -X POST -s https://api.fastly.com/service/<Service ID>/version/<Editable Version #>/snippet -H "Fastly-Key:FASTLY_API_TOKEN" -H `fastly-cookie` -H 'Content-Type: application/x-www-form-urlencoded'
--data $'name=my_regular_snippet&type=recv&dynamic=0&content=if ( req.url ) {\n set req.http.my-snippet-test-header = "true";\n}';

resource "fastly_service_v1" "www" {
  name = "testsvc"

  domain {
    name = "lab2.braingang.net"
    comment = "lab2 test"
  }

  backend {
    #address = "https://lab-development-lab2.s3-us-west-2.amazonaws.com"
    #address = "http://braingang.net.s3-website-us-east-1.amazonaws.com"
    address = "${aws_s3_bucket.lab2_bucket.bucket}.s3-website-${aws_s3_bucket.lab2_bucket.region}.amazonaws.com"
    name    = "AWS S3 hosting"
    port    = 80
  }

  #default_host = "http://braingang.net.s3-website-us-east-1.amazonaws.com"
  default_host = "${aws_s3_bucket.lab2_bucket.bucket}.s3-website-${aws_s3_bucket.lab2_bucket.region}.amazonaws.com"

  force_destroy = true

  blocked_ips = local.blocked_ips
}