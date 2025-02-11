import keras
from keras import layers
import numpy as np
import matplotlib.pyplot as plt
import csv

# Read training data from Gaussian runs:
with open('data.csv', 'r') as fptr:
    fptr_reader = csv.reader(fptr)
    A = [[float(v[0]), float(v[1])] for v in fptr_reader]

x_train, y_train = np.array(A, dtype=np.float64).T

# Create a neural network:
l_input = keras.Input(shape=(1,), dtype=np.float64, name='r')
l_1 = layers.Dense(64, activation='linear',
           kernel_initializer='uniform', use_bias=True,
           dtype=np.float64, name='l1')(l_input)
l_2 = layers.Dense(64, activation='gelu',
           kernel_initializer='uniform', use_bias=True,
           dtype=np.float64, name='l2')(l_1)
l_3 = layers.Dense(64, activation='linear',
           kernel_initializer='uniform', use_bias=True,
           dtype=np.float64, name='l_3')(l_2)
l_4 = layers.Dense(1, activation='linear',
           kernel_initializer='uniform', use_bias=True,
           dtype=np.float64, name='potential')(l_3)
model = keras.Model(inputs=l_input, outputs=l_4,
           dtype=np.float64)
model.compile(loss='mean_squared_error', optimizer='RMSprop')
model.summary()

# Interpolate additional training data points:
x_prime = np.arange(0.3,8.0,0.01)
y_prime = np.interp(x_prime, x_train, y_train)

# Watch for parameterizations that minimize the residuals
# and save the single best fit to a file; restore that best-fit
# to the model after fitting is complete:
checkpoint = keras.callbacks.ModelCheckpoint(
                   filepath='opt-model.keras',
                   monitor='loss',
                   verbose=1,
                   save_best_only=True,
                   mode='min')

# Do up to 2000 training epochs, leveraging the checkpoint
# object created above to retain the best-fit model; on each
# epoch present the training data in a randomized order:
history = model.fit(x_prime, y_prime,
                   epochs=2000, shuffle=True,
                   callbacks=(checkpoint,))

# Reload the best-fit model:
model = keras.models.load_model('opt-model.keras')

# Clear the plotting canvas:
plt.clf()

# Plot the model value over the range 0.3 to 8.0 Å:
x_plot_range = np.arange(0.3, 8.0, 0.1, dtype=np.float64)
plt.plot(x_plot_range, model.predict(x_plot_range), color='r')

# Plot the training data on top of the function:
plt.scatter(x_train, y_train, color='g')

# Add labels and title:
plt.xlabel('r/Å')
plt.ylabel('Eint/kcal•mol^-1')
plt.title('N2-N2 interaction potential')

# Save to a PNG file:
plt.savefig('neural-net.png')

