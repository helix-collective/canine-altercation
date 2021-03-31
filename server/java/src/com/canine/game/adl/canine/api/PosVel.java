/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class PosVel {

  /* Members */

  private Position position;
  private Velocity velocity;

  /* Constructors */

  public PosVel(Position position, Velocity velocity) {
    this.position = Objects.requireNonNull(position);
    this.velocity = Objects.requireNonNull(velocity);
  }

  public PosVel() {
    this.position = new Position();
    this.velocity = new Velocity();
  }

  public PosVel(PosVel other) {
    this.position = Position.FACTORY.create(other.position);
    this.velocity = Velocity.FACTORY.create(other.velocity);
  }

  /* Accessors and mutators */

  public Position getPosition() {
    return position;
  }

  public void setPosition(Position position) {
    this.position = Objects.requireNonNull(position);
  }

  public Velocity getVelocity() {
    return velocity;
  }

  public void setVelocity(Velocity velocity) {
    this.velocity = Objects.requireNonNull(velocity);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof PosVel)) {
      return false;
    }
    PosVel other = (PosVel) other0;
    return
      position.equals(other.position) &&
      velocity.equals(other.velocity);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + position.hashCode();
    _result = _result * 37 + velocity.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private Position position;
    private Velocity velocity;

    public Builder() {
      this.position = null;
      this.velocity = null;
    }

    public Builder setPosition(Position position) {
      this.position = Objects.requireNonNull(position);
      return this;
    }

    public Builder setVelocity(Velocity velocity) {
      this.velocity = Objects.requireNonNull(velocity);
      return this;
    }

    public PosVel create() {
      Builders.checkFieldInitialized("PosVel", "position", position);
      Builders.checkFieldInitialized("PosVel", "velocity", velocity);
      return new PosVel(position, velocity);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<PosVel> FACTORY = new Factory<PosVel>() {
    @Override
    public PosVel create() {
      return new PosVel();
    }

    @Override
    public PosVel create(PosVel other) {
      return new PosVel(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "PosVel");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<PosVel> jsonBinding() {
      return PosVel.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<PosVel> jsonBinding() {
    final Lazy<JsonBinding<Position>> position = new Lazy<>(() -> Position.jsonBinding());
    final Lazy<JsonBinding<Velocity>> velocity = new Lazy<>(() -> Velocity.jsonBinding());
    final Factory<PosVel> _factory = FACTORY;

    return new JsonBinding<PosVel>() {
      @Override
      public Factory<PosVel> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(PosVel _value) {
        JsonObject _result = new JsonObject();
        _result.add("p", position.get().toJson(_value.position));
        _result.add("v", velocity.get().toJson(_value.velocity));
        return _result;
      }

      @Override
      public PosVel fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new PosVel(
          JsonBindings.fieldFromJson(_obj, "p", position.get()),
          JsonBindings.fieldFromJson(_obj, "v", velocity.get())
        );
      }
    };
  }
}
