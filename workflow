package workflows

import (
	"time"

	"go.temporal.io/sdk/workflow"
)

func OrderWorkflow(ctx workflow.Context, orderID string) error {
	options := workflow.ActivityOptions{
		StartToCloseTimeout: time.Minute,
		RetryPolicy: &workflow.RetryPolicy{
			MaximumAttempts: 3,
		},
	}
	ctx = workflow.WithActivityOptions(ctx, options)

	err := workflow.ExecuteActivity(ctx, ChargePayment, orderID).Get(ctx, nil)
	if err != nil {
		return err
	}

	err = workflow.ExecuteActivity(ctx, ShipOrder, orderID).Get(ctx, nil)
	if err != nil {
		return err
	}

	return nil
}
