job "PYTHON_TEST" {
  datacenters = ["dc1"]

  group "PYTHON_EXEC" {

    task "PYTHON_SCRIPT" {
      driver = "exec"

      config {
        # When running a binary that exists on the host, the path must be absolute.
        command = "/bin/python"
        args = ["local/nomad.py"]
      }
    }
  }
}
