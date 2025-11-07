# 🧑‍💼 Employee Onboarding & Account Creation Scripts

This two-part Bash automation system streamlines the onboarding of new employees by collecting their information, storing it in structured CSV files, and creating Linux user accounts with temporary credentials.

---

## 📦 Components

### 1. `gather-user-info.sh`
- Collects employee data interactively.
- Confirms input before saving.
- Writes to:
  - `all-emp-ds.csv` (master log)
  - Department-specific CSVs (e.g., `HR/hr-emp-ds.csv`)

### 2. `create-user-acc.sh`
- Must be run as `root`.
- Reads from `all-emp-ds.csv`.
- Creates Linux user accounts for entries not yet marked as "Account Created".
- Updates the status field from `"NYC"` to `"Account Created"` to prevent duplication.
- Generates per-user credential files.

---

## 🧪 Usage

### 1. Run the Data Collection Script
```bash
chmod +x gather-user-info.sh
./gather-user-info.sh
```

### 2. Run the Account Creation Script (as root)
```bash
sudo ./create-user-acc.sh
```

---

## 📁 Output Directory Structure

```
new-emp-data-store/
├── all-emp-ds.csv
├── HR/
│   └── hr-emp-ds.csv
├── IT/
│   └── it-emp-ds.csv
├── FIN/
│   └── fin-emp-ds.csv
├── OTH/
│   └── gen-emp-ds.csv
└── temp/
    └── <username>-credentials.txt
```

---

## 🔄 Scalability

Adding new departments is simple and modular:

### ✅ To Add a Department:
1. Add a new `case` block in `gather-user-info.sh`:
   ```bash
   "Legal")
       mkdir -p "$new_emp_data_store/LEGAL"
       echo "$CSV_ROW" >> "$new_emp_data_store/LEGAL/legal-emp-ds.csv"
       ;;
   ```

2. No changes are needed in `create-user-acc.sh` — it reads from the master CSV.

### 🧩 Why This Is Scalable:
- Department routing is isolated to a single `case` block.
- Folder creation is dynamic (`mkdir -p`).
- Status tracking prevents duplicate account creation.
- Credential files are modular and per-user.

---

## 🛡️ Notes

- Ensure `openssl` is installed for password generation.
- Email sending is simulated — replace with real SMTP logic if needed.
- The `"NYC"` marker is used as a placeholder for unprocessed users.
