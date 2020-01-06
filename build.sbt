name := "riscv-blinky"

version := "0.1.0"

scalaVersion := "2.11.12"

libraryDependencies ++= Seq(
  "com.github.spinalhdl" % "spinalhdl-core_2.11" % "latest.release",
  "com.github.spinalhdl" % "spinalhdl-lib_2.11" % "latest.release"
)

fork := true

lazy val root = Project("root", file("."))
    .dependsOn(vexRiscV)
lazy val vexRiscV = RootProject(uri("https://github.com/SpinalHDL/VexRiscv.git"))