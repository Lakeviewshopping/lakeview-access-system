/ Fetch assignments
async function fetchAssignments() {
    try {
        const response = await fetch(`${apiUrl}/assignments`);
        if (!response.ok) throw new Error('Failed to fetch assignments');
        const assignments = await response.json();
        const assignmentList = document.getElementById('assignment-list');
        assignmentList.innerHTML = assignments.map(a => `<li>${a.title}: ${a.description} (Due: ${new Date(a.due_date).toLocaleString()})</li>`).join('');
    } catch (error) {
        console.error('Error fetching assignments:', error);
        alert('Error fetching assignments. Please try again.');
    }
}

// Add assignment
document.getElementById('assignment-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    const title = document.getElementById('assignment-title').value;
    const description = document.getElementById('assignment-description').value;
    const dueDate = document.getElementById('assignment-due').value;

    try {
        await fetch(`${apiUrl}/assignments`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ title, description, due_date: dueDate }),
        });
        fetchAssignments(); // Refresh the list
    } catch (error) {
        console.error('Error adding assignment:', error);
        alert('Error adding assignment. Please try again.');
    }
});

// Update user role
document.getElementById('role-form').addEventListener('submit', async (event) => {
    event.preventDefault();
    const userId = document.getElementById('manage-user-id').value;
    const isSiteAdmin = document.getElementById('is-site-admin').value === 'true';

    try {
        await fetch(`${apiUrl}/users/${userId}/role`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ is_site_admin: isSiteAdmin }),
        });
        alert(`User ID ${userId} role updated successfully!`);
    } catch (error) {
        console.error('Error updating user role:', error);
        alert('Error updating user role. Please try again.');
    }
});

// Initial fetch for assignments on page load
fetchAssignments();
