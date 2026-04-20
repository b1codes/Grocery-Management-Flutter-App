from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.db.models import Sum
from django.db.models.functions import TruncDay
from apps.budget.models import MonthlyBudget
from apps.budget.serializers import BudgetSerializer
from apps.grocery.models import GroceryTrip
import datetime


class BudgetViewSet(viewsets.ModelViewSet):
    queryset = MonthlyBudget.objects.all()
    serializer_class = BudgetSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        queryset = self.queryset.filter(user=self.request.user)
        month = self.request.query_params.get('month')
        year = self.request.query_params.get('year')
        if month:
            queryset = queryset.filter(month=month)
        if year:
            queryset = queryset.filter(year=year)
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def perform_update(self, serializer):
        serializer.save()

    def perform_destroy(self, instance):
        instance.delete()

    @action(detail=False, methods=['get'], url_path='stats')
    def stats(self, request):
        month = request.query_params.get('month')
        year = request.query_params.get('year')

        if not month or not year:
            now = datetime.datetime.now()
            month = now.month
            year = now.year
        else:
            try:
                month = int(month)
                year = int(year)
            except ValueError:
                return Response({"error": "Invalid month or year"}, status=status.HTTP_400_BAD_REQUEST)

        # 1. Fetch budget
        budget = MonthlyBudget.objects.filter(user=request.user, month=month, year=year).first()
        budget_amount = budget.budget_amount if budget else 0

        # 2. Fetch trips for the month
        trips = GroceryTrip.objects.filter(
            user=request.user,
            trip_date__month=month,
            trip_date__year=year
        )

        # 3. Aggregate total spent
        total_spent = trips.aggregate(Sum('total_spent'))['total_spent__sum'] or 0

        # 4. Aggregate daily spending
        daily_spending = trips.annotate(day=TruncDay('trip_date')) \
            .values('day') \
            .annotate(amount=Sum('total_spent')) \
            .order_by('day')

        spending_trends = [
            {"date": item['day'].strftime('%Y-%m-%d'), "amount": float(item['amount'])}
            for item in daily_spending
        ]

        return Response({
            "month": month,
            "year": year,
            "budget_amount": float(budget_amount),
            "total_spent": float(total_spent),
            "spending_trends": spending_trends
        })