// app.js
document.addEventListener("DOMContentLoaded", function () {
    const numNodesInput = document.getElementById("numNodes");
    const connectionWaySelect = document.getElementById("connectionWay");
    const nodeInfoFields = document.getElementById("nodeInfoFields");

    numNodesInput.addEventListener("change", () => {
        const numNodes = numNodesInput.value;
        const connectionWay = connectionWaySelect.value;

        // Clear previous fields
        nodeInfoFields.innerHTML = "";

        // Add fields for each node
        for (let i = 1; i <= numNodes; i++) {
            const nodeFieldset = document.createElement("fieldset");
            nodeFieldset.innerHTML = `
                <legend>Node ${i} Information</legend>
                <label for="ip${i}">IP Address:</label>
                <input type="text" id="ip${i}" name="ip${i}" required><br><br>
                <label for="user${i}">User:</label>
                <input type="text" id="user${i}" name="user${i}" required><br><br>
                <label for="nodeName${i}">Node Name:</label>
                <input type="text" id="nodeName${i}" name="nodeName${i}" required><br><br>
                ${connectionWay === "0" ? `
                    <label for="password${i}">Password:</label>
                    <input type="password" id="password${i}" name="password${i}" required><br><br>
                ` : `
                    <label for="sshKeyPath${i}">SSH Key Path:</label>
                    <input type="text" id="sshKeyPath${i}" name="sshKeyPath${i}" required><br><br>
                `}
            `;
            nodeInfoFields.appendChild(nodeFieldset);
        }
    });
});
