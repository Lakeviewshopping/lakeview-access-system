from flask import Flask, jsonify, request

app = Flask(__name__)

# Sample data (this would normally come from a database)
users = {
    1: {"username": "admin", "is_site_admin": True},
    2: {"username": "user1", "is_site_admin": False},
}
assignments = []

@app.route('/assignments', methods=['GET', 'POST'])
def manage_assignments():
    if request.method == 'POST':
        assignment = request.json
        assignments.append(assignment)
        return jsonify(assignment), 201
    return jsonify(assignments)

@app.route('/users/<int:user_id>/role', methods=['PATCH'])
def update_user_role(user_id):
    is_site_admin = request.json.get('is_site_admin')
    if user_id in users:
        users[user_id]['is_site_admin'] = is_site_admin
        return jsonify(users[user_id]), 200
    return jsonify({'error': 'User not found'}), 404

if __name__ == '__main__':
    app.run(debug=True)
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lakeview Access</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <header>
        <img src="path_to_your_logo.png" alt="Lakeview Access Logo" class="logo">
        <h1>Lakeview Access</h1>
    </header>
    <main>
        <section>
            <h2>Add Assignment</h2>
            <form id="assignment-form">
                <input type="text" id="assignment-title" placeholder="Title" required>
                <textarea id="assignment-description" placeholder="Description" required></textarea>
                <input type="datetime-local" id="assignment-due" required>
                <button type="submit">Add Assignment</button>
            </form>
        </section>
        <section>
            <h2>Assignments</h2>
            <ul id="assignment-list"></ul>
        </section>
        <section>
            <h2>User Role Management</h2>
            <form id="role-form">
                <input type="number" id="manage-user-id" placeholder="User ID" required>
                <label for="is-site-admin">Site Admin:</label>
                <select id="is-site-admin">
                    <option value="true">Yes</option>
                    <option value="false">No</option>
                </select>
                <button type="submit">Update Role</button>
            </form>
        </section>
    </main>
    <script src="/static/script.js"></script>
</body>
</html>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}

header {
    background: #007bff;
    color: white;
    padding: 20px;
    text-align: center;
    border-bottom: 2px solid #0056b3;
}

h1 {
    margin: 0;
}

.logo {
    max-width: 100px;
}

main {
    padding: 20px;
}

section {
    background: white;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

form {
    margin-bottom: 20px;
}

input, textarea, select {
    width: calc(100% - 22px); /* Subtract padding */
    padding: 10px;
    margin: 5px 0;
    border: 1px solid #ccc;
    border-radius: 4px;
    transition: border 0.3s;
}

input:focus, textarea:focus, select:focus {
    border-color: #007bff;
    outline: none;
}

button {
    background: #007bff;
    color: white;
    border: none;
    padding: 10px 15px;
    cursor: pointer;
    border-radius: 4px;
    transition: background 0.3s;
}

button:hover {
    background: #0056b3;
}

ul {
    list-style-type: none;
    padding: 0;
}

li {
    padding: 5px;
    border-bottom: 1px solid #ddd;
}
const apiUrl = 'http://127.0.0.1:5000'; // Update with your API URL

// Fetch assignments
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
