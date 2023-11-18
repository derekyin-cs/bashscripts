import tkinter as tk
from tkcalendar import Calendar
from datetime import datetime

# Main application class
class TodoApp:
    def __init__(self, root):
        self.root = root
        self.root.title("To-Do List App")

        # Create frames
        self.frame_task = tk.Frame(self.root)
        self.frame_task.pack(pady=10)

        self.frame_completed = tk.Frame(self.root)
        self.frame_completed.pack(pady=10)

        # Add entry box
        self.task_name = tk.Entry(self.frame_task, width=50)
        self.task_name.grid(row=0, column=0, padx=5, pady=5)

        # Add priority dropdown
        self.priority_var = tk.StringVar(self.frame_task)
        self.priority_var.set("High")  # default value
        self.priority_options = ["Low", "Medium", "High"]
        self.priority_menu = tk.OptionMenu(self.frame_task, self.priority_var, *self.priority_options)
        self.priority_menu.grid(row=0, column=1, padx=5, pady=5)

        # Add calendar
        self.cal = Calendar(self.frame_task, selectmode='day', year=datetime.now().year, month=datetime.now().month, day=datetime.now().day)
        self.cal.grid(row=1, column=0, columnspan=2, padx=5, pady=5)

        # Add task list
        self.task_list = tk.Listbox(self.frame_task, width=75, height=10)
        self.task_list.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

        # Add button to add tasks
        self.add_button = tk.Button(self.frame_task, text="Add Task", command=self.add_task)
        self.add_button.grid(row=3, column=0, padx=5, pady=5)

        # Completed tasks list
        self.completed_list = tk.Listbox(self.frame_completed, width=75, height=5)
        self.completed_list.grid(row=0, column=0, columnspan=2, padx=5, pady=5)

        # Add button to mark tasks as complete
        self.complete_button = tk.Button(self.frame_completed, text="Mark Complete", command=self.mark_complete)
        self.complete_button.grid(row=1, column=0, padx=5, pady=5)

        # Add button to remove completed tasks
        self.remove_button = tk.Button(self.frame_completed, text="Remove Completed", command=self.remove_completed)
        self.remove_button.grid(row=1, column=1, padx=5, pady=5)

    # Add task function
    def add_task(self):
        task = self.task_name.get()
        if task:
            priority = self.priority_var.get()
            due_date = self.cal.get_date()
            task_entry = f"{task} - Priority: {priority} - Due Date: {due_date}"
            self.task_list.insert(tk.END, task_entry)
            self.task_name.delete(0, tk.END)

    # Mark task as complete
    def mark_complete(self):
        task = self.task_list.get(tk.ACTIVE)
        if task:
            self.completed_list.insert(tk.END, task)
            self.task_list.delete(tk.ACTIVE)

    # Remove completed task
    def remove_completed(self):
        self.completed_list.delete(tk.ACTIVE)

# Main window
root = tk.Tk()
app = TodoApp(root)
root.mainloop()
