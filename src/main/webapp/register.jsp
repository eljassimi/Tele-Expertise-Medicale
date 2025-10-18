<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Système Médical</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f3f0 0%, #e8e4df 100%);
        }

        .form-container {
            background: white;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
        }

        .input-field {
            transition: all 0.3s ease;
        }

        .input-field:focus {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(20, 108, 92, 0.15);
        }

        .submit-btn {
            background: linear-gradient(135deg, #146c5c 0%, #0f5449 100%);
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(20, 108, 92, 0.3);
        }

        .specialiste-fields {
            display: none;
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">

<div class="form-container w-full max-w-2xl rounded-2xl p-8 md:p-10">
    <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-teal-700 to-teal-900 rounded-full mb-4">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
            </svg>
        </div>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Créer un compte</h1>
        <p class="text-gray-600">Rejoignez notre système médical</p>
    </div>

    <c:if test="${not empty sessionScope.error}">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6">
                ${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <form action="register" method="post" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

        <div>
            <label for="role" class="block text-sm font-semibold text-gray-700 mb-2">
                Rôle professionnel <span class="text-red-500">*</span>
            </label>
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                    </svg>
                </div>
                <select
                        id="role"
                        name="role"
                        required
                        onchange="toggleSpecialisteFields()"
                        class="input-field w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900 appearance-none bg-white cursor-pointer"
                >
                    <option value="GENERALISTE">🩺 Médecin Généraliste</option>
                    <option value="SPECIALISTE">⚕️ Médecin Spécialiste</option>
                    <option value="INFIRMIER">💉 Infirmier(ère)</option>
                </select>
                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Nom -->
            <div>
                <label for="nom" class="block text-sm font-semibold text-gray-700 mb-2">
                    Nom <span class="text-red-500">*</span>
                </label>
                <input
                        type="text"
                        id="nom"
                        name="nom"
                        required
                        class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="Votre nom"
                />
            </div>

            <!-- Prénom -->
            <div>
                <label for="prenom" class="block text-sm font-semibold text-gray-700 mb-2">
                    Prénom <span class="text-red-500">*</span>
                </label>
                <input
                        type="text"
                        id="prenom"
                        name="prenom"
                        required
                        class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="Votre prénom"
                />
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Email -->
            <div>
                <label for="email" class="block text-sm font-semibold text-gray-700 mb-2">
                    Email
                </label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="exemple@email.com"
                />
            </div>

            <!-- Téléphone -->
            <div>
                <label for="telephone" class="block text-sm font-semibold text-gray-700 mb-2">
                    Téléphone
                </label>
                <input
                        type="tel"
                        id="telephone"
                        name="telephone"
                        class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="0612345678"
                />
            </div>
        </div>

        <!-- Username -->
        <div>
            <label for="username" class="block text-sm font-semibold text-gray-700 mb-2">
                Nom d'utilisateur <span class="text-red-500">*</span>
            </label>
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                    </svg>
                </div>
                <input
                        type="text"
                        id="username"
                        name="username"
                        required
                        class="input-field w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="Nom d'utilisateur unique"
                />
            </div>
        </div>

        <!-- Password -->
        <div>
            <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">
                Mot de passe <span class="text-red-500">*</span>
            </label>
            <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                </div>
                <input
                        type="password"
                        id="password"
                        name="password"
                        required
                        minlength="6"
                        class="input-field w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="Minimum 6 caractères"
                />
            </div>
        </div>

        <!-- Specialiste-specific fields (Hidden by default) -->
        <div id="specialisteFields" class="specialiste-fields space-y-4">
            <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
                <p class="text-sm text-blue-800">
                    <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    Informations supplémentaires requises pour les spécialistes
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Spécialité -->
                <div>
                    <label for="specialiteId" class="block text-sm font-semibold text-gray-700 mb-2">
                        Spécialité <span class="text-red-500">*</span>
                    </label>
                    <select
                            id="specialiteId"
                            name="specialiteId"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                    >
                        <option value="">Sélectionner une spécialité</option>
                        <c:forEach items="${specialites}" var="specialite">
                            <option value="${specialite.id}">${specialite.nom}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Tarif -->
                <div>
                    <label for="tarif" class="block text-sm font-semibold text-gray-700 mb-2">
                        Tarif (DH) <span class="text-red-500">*</span>
                    </label>
                    <input
                            type="number"
                            id="tarif"
                            name="tarif"
                            min="0"
                            step="0.01"
                            class="input-field w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                            placeholder="Ex: 300.00"
                    />
                </div>
            </div>
        </div>

        <button
                type="submit"
                class="submit-btn w-full py-3 px-4 text-white font-semibold rounded-xl focus:outline-none focus:ring-4 focus:ring-teal-700 focus:ring-opacity-30"
        >
            S'inscrire
        </button>

        <p class="text-center text-sm text-gray-600 mt-4">
            Vous avez déjà un compte ?
            <a href="login.jsp" class="text-teal-700 font-semibold hover:text-teal-900 transition-colors">
                Se connecter
            </a>
        </p>
    </form>
</div>

<script>
    function toggleSpecialisteFields() {
        const role = document.getElementById('role').value;
        const specialisteFields = document.getElementById('specialisteFields');
        const specialiteSelect = document.getElementById('specialiteId');
        const tarifInput = document.getElementById('tarif');

        if (role === 'SPECIALISTE') {
            specialisteFields.style.display = 'block';
            specialiteSelect.required = true;
            tarifInput.required = true;
        } else {
            specialisteFields.style.display = 'none';
            specialiteSelect.required = false;
            tarifInput.required = false;
            specialiteSelect.value = '';
            tarifInput.value = '';
        }
    }

    toggleSpecialisteFields();
</script>

</body>
</html>