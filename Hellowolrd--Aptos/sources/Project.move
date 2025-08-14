module MyModule::OnlineCourseAccess {

    use aptos_framework::signer;
    use std::vector;

    /// Stores course name & list of students with access
    struct Course has key {
        name: vector<u8>,
        students: vector<address>,
    }

    /// Create a course (owned by creator)
    public fun create_course(owner: &signer, course_name: vector<u8>) {
        let course = Course {
            name: course_name,
            students: vector::empty<address>(),
        };
        move_to(owner, course);
    }

    /// Grant course access to a student
    public fun grant_access(owner: &signer, student: address) acquires Course {
        let course = borrow_global_mut<Course>(signer::address_of(owner));
        if (!has_access(&course.students, student)) {
            vector::push_back(&mut course.students, student);
        }
    }

    /// Internal: check if student already has access
    fun has_access(students: &vector<address>, student: address): bool {
        let len = vector::length(students);
        let i = 0;
        while (i < len) {
            if (*vector::borrow(students, i) == student) {
                return true;
            };
            i = i + 1;
        };
        false
    }
}
