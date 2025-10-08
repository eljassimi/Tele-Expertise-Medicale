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

        .role-option {
            transition: all 0.2s ease;
        }

        select:focus .role-option {
            background-color: #f0fdf4;
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4">

<%-- Adjusted width from max-w-md to max-w-lg for better UX --%>
<div class="form-container w-full max-w-lg rounded-2xl p-8 md:p-10">
    <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-teal-700 to-teal-900 rounded-full mb-4">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
            </svg>
        </div>
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Créer un compte</h1>
        <p class="text-gray-600">Rejoignez notre système médical</p>
    </div>

    <%-- Removed all visible comment labels --%>
    <form action="register" method="post" class="space-y-6">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

        <div>
            <label for="username" class="block text-sm font-semibold text-gray-700 mb-2">
                Nom d'utilisateur
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
                        placeholder="Entrez votre nom d'utilisateur"
                />
            </div>
        </div>

        <div>
            <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">
                Mot de passe
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
                        class="input-field w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900"
                        placeholder="Entrez votre mot de passe"
                />
            </div>
        </div>

        <div>
            <label for="role" class="block text-sm font-semibold text-gray-700 mb-2">
                Rôle professionnel
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
                        class="input-field w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-teal-700 text-gray-900 appearance-none bg-white cursor-pointer"
                >
                    <option value="GENERALISTE" class="role-option">🩺 Généraliste</option>
                    <option value="SPECIALISTE" class="role-option">⚕️ Spécialiste</option>
                    <option value="INFIRMIER" class="role-option">💉 Infirmier</option>
                </select>
                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
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

</body>
</html>
