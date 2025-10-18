// functions/src/index.ts

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import {GoogleGenerativeAI} from "@google/generative-ai";

admin.initializeApp();
const db = admin.firestore();

export const generateInitialPlan = onDocumentCreated(
  {document: "users/{userId}", region: "europe-west3"},
  async (event) => {
    if (!process.env.GEMINI_API_KEY) {
      logger.error("GEMINI_API_KEY environment variable not set.");
      return;
    }
    const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

    const snapshot = event.data;
    if (!snapshot) {
      logger.error("No data associated with the event.");
      return;
    }

    const userData = snapshot.data();
    const userId = event.params.userId;
    const {profileData} = userData;

    logger.log(`Generating plan for new user: ${userId}`);

    const prompt = `
      You are Aura, a world-class AI nutritionist and fitness coach.
      Your task is to create a precise, personalized, and motivational
      baseline daily wellness plan for a new user.

      **Methodology:**
      1.  Calculate Basal Metabolic Rate (BMR) using the Mifflin-St Jeor 
          equation.
      2.  Determine Total Daily Energy Expenditure (TDEE) by applying an
          activity multiplier to the BMR based on the user's Activity Level:
          - sedentary: 1.2
          - lightlyActive: 1.375
          - moderatelyActive: 1.55
          - veryActive: 1.725
      3.  Adjust the TDEE based on the user's Primary Goal to get the final
          daily calorie target:
          - Lose Weight: TDEE - 500 calories.
          - Gain Weight or Build Muscle: TDEE + 300 calories.
          - Get Fit & Healthy: TDEE (maintenance).
      4.  Calculate macronutrient targets based on a balanced ratio of 40%
          carbohydrates, 30% protein, and 30% fat.

      **User Details:**
      - Height: ${profileData.height} cm
      - Weight: ${profileData.weight} kg
      - Age: ${profileData.age} years
      - Gender: ${profileData.gender}
      - Activity Level: ${profileData.activityLevel}
      - Primary Goal: ${profileData.goal}
      - Preferred Exercise: ${profileData.exercisePreference}
      
      **Cultural and Economic Context:**
      - User's Country of Residence: ${profileData.country || "Not provided"}
      - User's Budget for Groceries: ${profileData.budget || "Not provided"}
      
      This context is critical. The meal plan you generate MUST be
      culturally relevant and economically accessible for this user.
      If the country is provided, prioritize common, affordable, and seasonal 
      ingredients for that region. If the budget is 'budgetConscious', you MUST 
      avoid expensive or hard-to-find import items (like avocado, quinoa, 
      specialty berries, etc.) and focus on staples. If no context is provided,
      generate a globally balanced and affordable meal plan.

      **Output Requirements:**
      Generate the following in a VALID JSON format ONLY.
      Do not include any introductory text, explanations, or markdown.
      Your response MUST be ONLY the raw JSON object.

      {
        "dailyCalorieTarget": <integer>,
        "dailyProteinTarget": <integer>,
        "dailyCarbsTarget": <integer>,
        "dailyFatTarget": <integer>,
        "dailyWaterTargetMl": <integer, typically weight in kg * 35>,
        "welcomeMessage": "<A short, friendly, one-sentence welcome message>",
        "initialMealPlan": [
          {
            "name": "Breakfast",
            "icon": "free_breakfast_rounded",
            "items": [
              // --- THIS IS THE FIX ---
              // The long line has been broken into two.
              {"name": "<Food>", "quantity": "<Amount>", "calories": <int>,
               "protein": <int>},
              ...
            ]
          },
          {
            "name": "Lunch",
            "icon": "lunch_dining_rounded",
            "items": [...]
          },
          {
            "name": "Dinner",
            "icon": "dinner_dining_rounded",
            "items": [...]
          }
        ]
      }
      `;

    try {
      const model = genAI.getGenerativeModel({model: "gemini-2.5-flash"});
      const result = await model.generateContent(prompt);
      const response = result.response;
      if (!response || !response.text) {
        throw new Error("AI model returned an empty response.");
      }

      const text = response.text();
      logger.log("Received raw AI response:", text);

      const jsonMatch = text.match(/```json\s*([\s\S]*?)\s*```|({[\s\S]*})/);
      if (!jsonMatch || !jsonMatch[1] && !jsonMatch[2]) {
        throw new Error("Could not find a valid JSON in the AI response.");
      }
      const cleanedText = jsonMatch[1] || jsonMatch[2];

      logger.log("Cleaned JSON string:", cleanedText);

      const planData = JSON.parse(cleanedText);
      const userDocRef = db.collection("users").doc(userId);

      await userDocRef.update({
        todays_plan: planData,
      });

      logger.log("Successfully saved initial plan for user:", userId);
    } catch (error) {
      logger.error("Error generating or saving plan:", error);
    }
  });
