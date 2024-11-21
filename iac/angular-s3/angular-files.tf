locals {
  content_type_map = {
    "js"   = "text/javascript"
    "html" = "text/html"
    "css"  = "text/css"
    "ico"  = "image/x-icon"
  }
}

resource "aws_s3_object" "provision_source_files" {
  bucket       = aws_s3_bucket.angular_app_bucket.bucket
  for_each     = fileset(var.angular_build_folder_path, "**/*.*")
  key          = each.value
  source       = "${var.angular_build_folder_path}/${each.value}"
  content_type = lookup(local.content_type_map, reverse(split(".", each.value))[0], "binary/octet-stream")
  etag         = base64encode("${var.angular_build_folder_path}/${each.value}")
}
