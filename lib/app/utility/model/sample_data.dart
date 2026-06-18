// ── Static sample data — replace with API calls later ──────────

class PatientData {
  static const patient = {
    'name': 'Rahul Mehta',
    'rm': 'RM-2024-0042',
    'dob': '15 Mar 1990',
    'age': '35 years',
    'gender': 'Male',
    'blood': 'B+',
    'phone': '+91 98765 43210',
    'email': 'rahul.mehta@email.com',
    'address': '42, Shanti Nagar, Ahmedabad, Gujarat - 380001',
    'doctor': 'Dr. Priya Sharma',
    'clinic': 'ClinixPro Clinic',
  };

  static final List<Map<String, dynamic>> consultHistory = [
    {
      'date': '28 May 2025',
      'doctor': 'Dr. Priya Sharma',
      'diagnosis': 'Viral fever with cough',
      'symptoms': ['Fever (38.5°C)', 'Dry cough', 'Body ache', 'Fatigue'],
      'medicines': [
        {'name': 'Paracetamol 500mg', 'dose': '1 tablet', 'freq': 'Twice daily', 'dur': '5 days'},
        {'name': 'Cetirizine 10mg', 'dose': '1 tablet', 'freq': 'At night', 'dur': '3 days'},
        {'name': 'Amoxicillin 500mg', 'dose': '1 capsule', 'freq': 'Thrice daily', 'dur': '5 days'},
      ],
      'vitals': {'BP': '118/76', 'Pulse': '88 bpm', 'Temp': '38.5°C', 'SpO₂': '97%', 'Weight': '72 kg'},
      'investigations': ['CBC', 'CRP'],
      'advice': 'Take rest. Drink warm fluids. Avoid cold foods.',
      'followUp': '04 Jun 2025',
    },
    {
      'date': '10 Mar 2025',
      'doctor': 'Dr. Priya Sharma',
      'diagnosis': 'Hypertension — routine follow-up',
      'symptoms': ['Mild headache', 'Occasional dizziness'],
      'medicines': [
        {'name': 'Amlodipine 5mg', 'dose': '1 tablet', 'freq': 'Once daily morning', 'dur': '30 days'},
        {'name': 'Telmisartan 40mg', 'dose': '1 tablet', 'freq': 'Once daily morning', 'dur': '30 days'},
      ],
      'vitals': {'BP': '142/90', 'Pulse': '82 bpm', 'Temp': '36.8°C', 'SpO₂': '98%', 'Weight': '73 kg'},
      'investigations': ['Lipid profile', 'RFT', 'ECG'],
      'advice': 'Low salt diet. Exercise 30 min daily. Avoid stress.',
      'followUp': '10 Apr 2025',
    },
    {
      'date': '05 Jan 2025',
      'doctor': 'Dr. Priya Sharma',
      'diagnosis': 'Acute gastroenteritis',
      'symptoms': ['Loose stools (6 episodes)', 'Nausea', 'Mild fever'],
      'medicines': [
        {'name': 'ORS sachet', 'dose': '1 sachet in 1L water', 'freq': 'After every loose stool', 'dur': '3 days'},
        {'name': 'Metronidazole 400mg', 'dose': '1 tablet', 'freq': 'Thrice daily', 'dur': '5 days'},
        {'name': 'Ondansetron 4mg', 'dose': '1 tablet', 'freq': 'Twice daily', 'dur': '3 days'},
      ],
      'vitals': {'BP': '110/70', 'Pulse': '96 bpm', 'Temp': '37.8°C', 'SpO₂': '98%', 'Weight': '70 kg'},
      'investigations': ['Stool routine'],
      'advice': 'Plenty of fluids. Light diet (khichdi, curd rice). Avoid spicy food.',
      'followUp': '10 Jan 2025',
    },
  ];

  static final List<Map<String, dynamic>> reports = [
    {'name': 'CBC Report', 'date': '28 May 2025', 'type': 'Blood Test', 'size': '1.2 MB', 'icon': '🩸'},
    {'name': 'Lipid Profile', 'date': '10 Mar 2025', 'type': 'Blood Test', 'size': '890 KB', 'icon': '🩸'},
    {'name': 'ECG Report', 'date': '10 Mar 2025', 'type': 'Cardiology', 'size': '2.4 MB', 'icon': '❤️'},
    {'name': 'Chest X-Ray', 'date': '05 Jan 2025', 'type': 'Radiology', 'size': '4.1 MB', 'icon': '🫁'},
    {'name': 'RFT Report', 'date': '10 Mar 2025', 'type': 'Blood Test', 'size': '760 KB', 'icon': '🩸'},
    {'name': 'Stool Routine', 'date': '05 Jan 2025', 'type': 'Pathology', 'size': '540 KB', 'icon': '🧪'},
    {'name': 'CRP Report', 'date': '28 May 2025', 'type': 'Blood Test', 'size': '620 KB', 'icon': '🩸'},
    {'name': 'USG Abdomen', 'date': '05 Jan 2025', 'type': 'Radiology', 'size': '5.8 MB', 'icon': '🔬'},
  ];

  static final List<Map<String, dynamic>> messages = [
    {
      'isMe': false,
      'text': 'Hello Rahul, hope you are feeling better. Please remember to take your medicines on time.',
      'time': '10:30 AM',
      'sender': 'Dr. Priya Sharma',
    },
    {
      'isMe': true,
      'text': 'Thank you Doctor. I am feeling much better now. The fever has gone down.',
      'time': '10:45 AM',
      'sender': 'Me',
    },
    {
      'isMe': false,
      'text': 'That is great to hear! Please complete the full course of antibiotics even if you feel better. Also get the CBC test done before your next visit.',
      'time': '10:47 AM',
      'sender': 'Dr. Priya Sharma',
    },
    {
      'isMe': true,
      'text': 'Sure Doctor. I will get the test done. Should I come for follow up on 4th June as you mentioned?',
      'time': '11:00 AM',
      'sender': 'Me',
    },
    {
      'isMe': false,
      'text': 'Yes, please come on 4th June at 10 AM. We will review your test reports and check your recovery. If you have any discomfort before that, do not hesitate to message here.',
      'time': '11:05 AM',
      'sender': 'Dr. Priya Sharma',
    },
    {
      'isMe': true,
      'text': 'Thank you so much Doctor. I will be there on 4th June.',
      'time': '11:10 AM',
      'sender': 'Me',
    },
  ];

  static final List<Map<String, dynamic>> timeSlots = [
    {'time': '09:00 AM', 'available': true},
    {'time': '09:30 AM', 'available': false},
    {'time': '10:00 AM', 'available': true},
    {'time': '10:30 AM', 'available': true},
    {'time': '11:00 AM', 'available': false},
    {'time': '11:30 AM', 'available': true},
    {'time': '12:00 PM', 'available': false},
    {'time': '12:30 PM', 'available': true},
    {'time': '05:00 PM', 'available': true},
    {'time': '05:30 PM', 'available': true},
    {'time': '06:00 PM', 'available': false},
    {'time': '06:30 PM', 'available': true},
  ];

  static final List<Map<String, dynamic>> appointments = [
    {
      'date': '04 Jun 2025',
      'time': '10:00 AM',
      'doctor': 'Dr. Priya Sharma',
      'type': 'Follow-up',
      'status': 'Confirmed',
      'fee': '₹500',
    },
    {
      'date': '10 Apr 2025',
      'time': '11:30 AM',
      'doctor': 'Dr. Priya Sharma',
      'type': 'Routine Check-up',
      'status': 'Completed',
      'fee': '₹500',
    },
    {
      'date': '10 Jan 2025',
      'time': '09:30 AM',
      'doctor': 'Dr. Priya Sharma',
      'type': 'Follow-up',
      'status': 'Completed',
      'fee': '₹500',
    },
  ];

  static final List<Map<String, dynamic>> notifications = [
    {
      'type': 'followup',
      'title': 'Follow-up Reminder',
      'body': 'Your follow-up appointment with Dr. Priya Sharma is scheduled for 4th June 2025 at 10:00 AM.',
      'time': '2 hours ago',
      'read': false,
      'icon': '📅',
    },
    {
      'type': 'vaccination',
      'title': 'Vaccination Due',
      'body': 'Your annual Influenza (Flu) vaccination is due this month. Please visit the clinic to get vaccinated.',
      'time': '1 day ago',
      'read': false,
      'icon': '💉',
    },
    {
      'type': 'medicine',
      'title': 'Medicine Reminder',
      'body': 'Remember to take your evening dose of Amlodipine 5mg and Telmisartan 40mg.',
      'time': '2 days ago',
      'read': true,
      'icon': '💊',
    },
    {
      'type': 'report',
      'title': 'Report Uploaded',
      'body': 'Your CBC report dated 28 May 2025 has been uploaded by the clinic. Tap to view.',
      'time': '3 days ago',
      'read': true,
      'icon': '📋',
    },
    {
      'type': 'appointment',
      'title': 'Appointment Confirmed',
      'body': 'Your appointment on 04 Jun 2025 at 10:00 AM has been confirmed. Payment of ₹500 received.',
      'time': '4 days ago',
      'read': true,
      'icon': '✅',
    },
    {
      'type': 'vaccination',
      'title': 'Typhoid Vaccination Reminder',
      'body': 'Typhoid vaccination is recommended every 3 years. Your last dose was in Jan 2023. Please schedule your booster.',
      'time': '1 week ago',
      'read': true,
      'icon': '💉',
    },
    {
      'type': 'message',
      'title': 'New Message from Clinic',
      'body': 'Dr. Priya Sharma has sent you a message regarding your recent test results.',
      'time': '1 week ago',
      'read': true,
      'icon': '💬',
    },
    {
      'type': 'followup',
      'title': 'BP Check Reminder',
      'body': 'Please check your blood pressure daily and note the readings to share with Dr. Sharma on your next visit.',
      'time': '2 weeks ago',
      'read': true,
      'icon': '❤️',
    },
  ];
}
