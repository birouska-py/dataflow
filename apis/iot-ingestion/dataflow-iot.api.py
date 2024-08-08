from flask import Flask, request, jsonify, send_from_directory
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.exceptions import HTTPException
import uuid
from datetime import datetime
import os

app = Flask(__name__)
CORS(app)  # Habilitar CORS para todas as rotas

# Configure PostgreSQL database connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost:5432/dataflow'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Equipment(db.Model):
    __tablename__ = 'dim_equipment'
    __table_args__ = {'schema': 'dw'}
    
    id = db.Column(db.String, primary_key=True, default=lambda: str(uuid.uuid4()))
    model = db.Column(db.String, nullable=False)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date)

class Driver(db.Model):
    __tablename__ = 'dim_driver'
    __table_args__ = {'schema': 'dw'}
    
    id = db.Column(db.String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = db.Column(db.String, nullable=False)
    birth_date = db.Column(db.Date, nullable=False)
    identification_document = db.Column(db.String, nullable=False)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date)
    client_id = db.Column(db.String, db.ForeignKey('dw.dim_client.id'), nullable=False)

class Event(db.Model):
    __tablename__ = 'dim_event'
    __table_args__ = {'schema': 'dw'}
    
    id = db.Column(db.String, primary_key=True, default=lambda: str(uuid.uuid4()))
    event = db.Column(db.String, nullable=False)
    severity_classification = db.Column(db.String, nullable=False)

# Define the Position model within the 'dataflow' schema
class Position(db.Model):
    __tablename__ = 'fct_position'
    __table_args__ = {'schema': 'dw'}
    
    id = db.Column(db.String, primary_key=True, default=lambda: str(uuid.uuid4()))
    dtposition = db.Column(db.DateTime, nullable=False)
    dtarrived = db.Column(db.DateTime, default=datetime.utcnow)
    long = db.Column(db.Float, nullable=False)
    lat = db.Column(db.Float, nullable=False)
    odometer = db.Column(db.Float, nullable=False)
    consume = db.Column(db.Float, nullable=False)
    speedy = db.Column(db.Float, nullable=False)
    equipment_id = db.Column(db.String, db.ForeignKey('dw.dim_equipment.id'), nullable=False)
    carddriver = db.Column(db.String, db.ForeignKey('dw.dim_driver.id'), nullable=False)
    event_id = db.Column(db.String, db.ForeignKey('dw.dim_event.id'), nullable=False)

@app.route('/positions', methods=['POST'])
def create_position():
    data = request.json
    new_position = Position(
        dtposition=datetime.fromisoformat(data['dtposition']),
        long=data['long'],
        lat=data['lat'],
        odometer=data['odometer'],
        consume=data['consume'],
        speedy=data['speedy'],
        equipment_id=data['equipment_id'],
        carddriver=data['carddriver'],
        event_id=data['event_id']
    )
    db.session.add(new_position)
    db.session.commit()
    return jsonify({
        'id': new_position.id,
        'dtposition': new_position.dtposition.isoformat(),
        'dtarrived': new_position.dtarrived.isoformat(),
        'long': new_position.long,
        'lat': new_position.lat,
        'odometer': new_position.odometer,
        'consume': new_position.consume,
        'speedy': new_position.speedy,
        'equipment_id': new_position.equipment_id,
        'carddriver': new_position.carddriver,
        'event_id': new_position.event_id
    }), 201

@app.route('/swagger/<path:path>')
def send_swagger(path):
    return send_from_directory('.', path)

@app.route('/docs')
def swagger_ui():
    return send_from_directory('.', 'swagger-ui.html')

# Global error handler
@app.errorhandler(Exception)
def handle_exception(e):
    response = {
        "error": type(e).__name__,
        "message": str(e)
    }
    status_code = 500
    if isinstance(e, HTTPException):
        status_code = e.code
    return jsonify(response), status_code



if __name__ == '__main__':
    app.run(debug=True)
