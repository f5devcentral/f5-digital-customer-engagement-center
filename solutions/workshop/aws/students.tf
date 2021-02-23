// students
variable "students" {
  description = "Map of student names"
  type        = map(any)
  default = {
    student1 = {
      projectPrefix = "workshop-student-1",
      resourceOwner = "student1"
    },
    student2 = {
      projectPrefix = "workshop-student-2",
      resourceOwner = "student2"
    }
  }
}
