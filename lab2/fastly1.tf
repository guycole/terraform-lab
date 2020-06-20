#
# Title:fastly1.tf
# Description: create a fastly service to S3, ban some IP address
# Development Environment: OS X 10.13.6/Terraform v0.12.24
#
locals {
  acl_name = "block_list"
  acl_entries = [
    {
      ip      = "1.2.3.4"
      comment = "block 1"
    },
    {
      ip      = "54.245.143.7"
      comment = "block 2"
    }
  ]
}

resource "fastly_service_v1" "www" {
  name = "testsvc"

  domain {
    name    = "lab2.braingang.net"
    comment = "lab2 test"
  }

  backend {
    address = "${aws_s3_bucket.lab2_bucket.bucket}.s3-website-${aws_s3_bucket.lab2_bucket.region}.amazonaws.com"
    name    = "AWS S3 hosting"
    port    = 80
  }

  default_host = "${aws_s3_bucket.lab2_bucket.bucket}.s3-website-${aws_s3_bucket.lab2_bucket.region}.amazonaws.com"

  acl {
    name = local.acl_name
  }

  dynamicsnippet {
    name     = "tor_killer"
    type     = "recv"
    priority = 110
  }

  force_destroy = true
}

output "diag1" {
  value = local.acl_name
}

resource "fastly_service_acl_entries_v1" "blocked" {
  service_id = fastly_service_v1.www.id

  acl_id = { for dd in fastly_service_v1.www.acl : dd.name => dd.acl_id }[local.acl_name]

  dynamic "entry" {
    for_each = [for ee in local.acl_entries : {
      ip      = ee.ip
      comment = ee.comment
    }]

    content {
      ip      = entry.value.ip
      subnet  = 22
      comment = entry.value.comment
      negated = false
    }
  }
}

resource "fastly_service_dynamic_snippet_content_v1" "tor_killer" {
  service_id = fastly_service_v1.www.id
  snippet_id = { for s in fastly_service_v1.www.dynamicsnippet : s.name => s.snippet_id }["tor_killer"]
  content = "if (client.geo.proxy_description ~ \"^tor-\") { error 403; }"
}